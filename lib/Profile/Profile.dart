import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_service_app/Profile/edit_profile_page.dart';
import 'package:home_service_app/models/user_models.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  ImageProvider _getProfileImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const AssetImage("assets/default_avatar.png");
    }

    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    }

    if (imageUrl.startsWith('data:image')) {
      try {
        final bytes = base64Decode(imageUrl.split(',').last);
        return MemoryImage(bytes);
      } catch (e) {
        print('Error decoding base64 image: $e');
        return const AssetImage("assets/default_avatar.png");
      }
    }

    return const AssetImage("assets/default_avatar.png");
  }

  Future<void> _loadUserProfile() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          setState(() {
            _user = UserModel.fromMap(doc.data()!);
            _isLoading = false;
          });
        } else {
          // Create user document if it doesn't exist
          final newUser = UserModel(
            uid: user.uid,
            email: user.email,
            name: user.displayName ?? 'User',
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(newUser.toMap());

          setState(() {
            _user = newUser;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() => _isLoading = false);
    }
  }

  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF007BFF);
    const Color lightBackground = Color(0xFFF7F9FB);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: lightBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("User Profile"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Avatar
            Column(
              children: [
                // In your UserProfilePage build method, update the CircleAvatar:
                CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryBlue,
                  backgroundImage: _getProfileImage(_user?.profileImage),
                  child:
                      _user?.profileImage == null ||
                          _user!.profileImage!.isEmpty
                      ? Text(
                          _getInitials(_user?.name ?? 'User'),
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),

                // Add this helper method to UserProfilePage class:
                const SizedBox(height: 10),
                Text(
                  _user?.name ?? 'User',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _user?.email ?? 'No email',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Personal Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Personal Information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Divider(),
                    infoRow(
                      Icons.phone,
                      "Phone Number",
                      _user?.phone ?? "Not set",
                    ),
                    infoRow(Icons.email, "Email", _user?.email ?? "Not set"),
                    infoRow(
                      Icons.home,
                      "Location",
                      _user?.location ?? "Not set",
                    ),
                    infoRow(Icons.person, "Gender", _user?.gender ?? "Not set"),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditUserProfilePage(user: _user!),
                          ),
                        ).then((_) => _loadUserProfile());
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Log Out",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(value, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
