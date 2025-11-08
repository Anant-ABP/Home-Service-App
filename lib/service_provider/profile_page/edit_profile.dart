import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'dart:convert'; // for base64 encoding/decoding
import 'new_photo/select_new_photo.dart';

class EditProfilePage extends StatefulWidget {
  final String? name;
  final String? phone;
  final String? location;
  final String? gender;
  final File? image;

  const EditProfilePage({
    super.key,
    this.name,
    this.phone,
    this.location,
    this.gender,
    this.image,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  String? _gender;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.name ?? "");
    _phoneController = TextEditingController(text: widget.phone ?? "");
    _locationController = TextEditingController(text: widget.location ?? "");
    _gender = widget.gender;

    _profileImage = widget.image;
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      print("📸 Compressing image...");

      // Read and decode the image
      final originalBytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(originalBytes);

      if (originalImage == null) {
        print("❌ Failed to decode image");
        return null;
      }

      // Resize image to max 300x300 pixels to reduce size
      final resizedImage = img.copyResize(
        originalImage,
        width: 300,
        height: 300,
      );

      // Encode as JPEG with 70% quality
      final compressedBytes = img.encodeJpg(resizedImage, quality: 70);

      // Convert to base64
      final base64String = base64Encode(compressedBytes);

      print("📊 Original size: ${originalBytes.length} bytes");
      print("📊 Compressed size: ${compressedBytes.length} bytes");
      print("📊 Base64 size: ${base64String.length} bytes");

      if (base64String.length > 1000000) {
        // 1MB limit
        print("❌ Image still too large after compression");
        return null;
      }

      return "data:image/jpeg;base64,$base64String";
    } catch (e) {
      print("🔥 Image processing error: $e");
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    print("🔄 Starting profile save process...");

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      String? imageUrl;

      print("👤 User UID: $uid");
      print("📸 Selected image: $_profileImage");

      // Get current data first
      final existingData = await FirebaseFirestore.instance
          .collection("workers")
          .doc(uid)
          .get();

      String? currentImageUrl = existingData.data()?["profileImage"];
      print("🖼️ Current image URL in DB: $currentImageUrl");

      // Upload new image if selected
      if (_profileImage != null) {
        print("⬆️ Starting image upload...");
        imageUrl = await _uploadImageToFirebase(_profileImage!);
        print("✅ Image upload completed: $imageUrl");
      } else {
        // Keep existing image
        imageUrl = currentImageUrl;
        print("🔄 No new image selected, keeping existing: $imageUrl");
      }

      // Prepare update data
      final updateData = {
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "location": _locationController.text.trim(),
        "gender": _gender,
        "profileImage": imageUrl,
        "updatedAt": FieldValue.serverTimestamp(),
      };

      print("📝 Data to be saved: $updateData");

      // Update Firestore
      await FirebaseFirestore.instance
          .collection("workers")
          .doc(uid)
          .set(updateData, SetOptions(merge: true));

      print("🎉 Profile saved successfully!");

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print("❌ Error saving profile: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage("assets/default_avatar.png")
                                as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _changeProfileImage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your name" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: "Gender"),
                items: ["Male", "Female", "Other"]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _gender = val),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
