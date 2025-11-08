import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:home_service_app/models/user_models.dart';
import 'package:home_service_app/Profile/select_photo_page.dart';

class EditUserProfilePage extends StatefulWidget {
  final UserModel user;

  const EditUserProfilePage({super.key, required this.user});

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late String _gender;
  File? _profileImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name ?? '');
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _locationController = TextEditingController(
      text: widget.user.location ?? '',
    );
    _gender = widget.user.gender ?? '';
  }

  // Convert image to base64 for Firestore storage
  Future<String?> _imageToBase64(File imageFile) async {
    try {
      print("📸 Converting image to base64...");

      final bytes = await imageFile.readAsBytes();

      // Check file size - reject if too large
      if (bytes.length > 500000) {
        // 500KB limit
        print("❌ Image too large for Firestore (${bytes.length} bytes)");
        return null;
      }

      final base64String = base64Encode(bytes);

      if (base64String.length > 900000) {
        print("❌ Base64 string too large for Firestore");
        return null;
      }

      print("✅ Image converted successfully (${base64String.length} bytes)");
      return "data:image/jpeg;base64,$base64String";
    } catch (e) {
      print("🔥 Image conversion error: $e");
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? imageUrl;

        // Process new image if selected
        if (_profileImage != null) {
          print("🔄 Processing new profile image...");
          imageUrl = await _imageToBase64(_profileImage!);
        } else {
          // Keep existing image
          imageUrl = widget.user.profileImage;
          print("🔄 No new image selected, keeping existing");
        }

        // Prepare update data
        final updateData = {
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'location': _locationController.text.trim(),
          'gender': _gender,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        // Only add profileImage if we have a value
        if (imageUrl != null) {
          updateData['profileImage'] = imageUrl;
        }

        print("📝 Saving profile data...");
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(updateData, SetOptions(merge: true));

        print("✅ Profile saved successfully!");
        Navigator.pop(context);
      }
    } catch (e) {
      print('❌ Error saving profile: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _changeProfileImage() async {
    final File? selectedImage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectPhotoPage()),
    );

    if (selectedImage != null) {
      setState(() => _profileImage = selectedImage);
      print("✅ New image selected: ${selectedImage.path}");
    }
  }

  ImageProvider _getProfileImage() {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    }
    if (widget.user.profileImage != null &&
        widget.user.profileImage!.isNotEmpty) {
      if (widget.user.profileImage!.startsWith('data:image')) {
        try {
          final bytes = base64Decode(widget.user.profileImage!.split(',').last);
          return MemoryImage(bytes);
        } catch (e) {
          print('Error decoding base64 image: $e');
        }
      }
    }
    return const AssetImage("assets/default_avatar.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: _isSaving
                ? const CircularProgressIndicator()
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Image Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _getProfileImage(),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: _changeProfileImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender.isNotEmpty ? _gender : null,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
