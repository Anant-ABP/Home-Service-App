import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmNewPasswordPage extends StatefulWidget {
  final String phoneNumber;
  final String otp;
  final String verificationId;

  const ConfirmNewPasswordPage({
    super.key,
    required this.phoneNumber,
    required this.otp,
    required this.verificationId,
  });

  @override
  State<ConfirmNewPasswordPage> createState() => _ConfirmNewPasswordPageState();
}

class _ConfirmNewPasswordPageState extends State<ConfirmNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool _otpVerified = false;

  // Updated OTP verification method
  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty || _otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid 6-digit OTP"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // METHOD 1: Verify with Firebase Phone Auth (Recommended)
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: _otpController.text,
        );

        // Sign in with the credential
        await _auth.signInWithCredential(credential);

        print('OTP verified successfully with Firebase Auth');
      } catch (firebaseAuthError) {
        print('Firebase Auth verification failed: $firebaseAuthError');

        // METHOD 2: Fallback to Firestore verification
        final otpDoc = await _firestore
            .collection('password_reset_otp')
            .doc(widget.phoneNumber)
            .get();

        if (!otpDoc.exists || otpDoc.data()?['otp'] != _otpController.text) {
          throw Exception('Invalid OTP');
        }

        // Check if OTP is expired (5 minutes)
        final createdAt = otpDoc.data()?['createdAt'] as Timestamp;
        final now = DateTime.now();
        final difference = now.difference(createdAt.toDate()).inMinutes;

        if (difference > 5) {
          throw Exception('OTP expired');
        }
      }

      setState(() {
        _otpVerified = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP verified successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error verifying OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  // Reset Password
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Find user by phone number
      final userQuery = await _firestore
          .collection('users')
          .where('phone', isEqualTo: widget.phoneNumber)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not found."),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      final userDoc = userQuery.docs.first;
      final newPassword = _newPasswordController.text;

      // OPTION 1: Update only in Firestore (if you use Firestore for authentication)
      await _firestore.collection('users').doc(userDoc.id).update({
        'password': newPassword,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // OPTION 2: If you use Firebase Auth, try to update there too
      try {
        User? currentUser = _auth.currentUser;
        if (currentUser != null) {
          await currentUser.updatePassword(newPassword);
          print('Password updated in Firebase Auth');
        }
      } catch (e) {
        print('Could not update Firebase Auth: $e');
        // This is normal if user is not logged in
      }

      // Delete used OTP
      await _firestore
          .collection('password_reset_otp')
          .doc(widget.phoneNumber)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login page
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error resetting password: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error resetting password: $e"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _otpVerified
                      ? "Create your new password"
                      : "Verify OTP sent to ${widget.phoneNumber}",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 30),

                if (!_otpVerified) ...[
                  // OTP Field
                  TextFormField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      labelText: "Enter OTP",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "123456",
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter OTP";
                      }
                      if (value.length != 6) {
                        return "OTP must be 6 digits";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Verify OTP Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _verifyOtp,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text("Verify OTP"),
                  ),
                ] else ...[
                  // New Password Field
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter new password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm New Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != _newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Reset Password Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _resetPassword,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text("Reset Password"),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
