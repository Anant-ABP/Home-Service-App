import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_service_app/service_provider/profile_page/new_photo/select_new_photo.dart';

class EditProfilePage extends StatefulWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? location;
  final String? gender;
  final File? image;

  const EditProfilePage({
    super.key,
    this.name,
    this.email,
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
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  String? _gender;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.name ?? "");
    _emailController = TextEditingController(text: widget.email ?? "");
    _phoneController = TextEditingController(text: widget.phone ?? "");
    _locationController = TextEditingController(text: widget.location ?? "");
    _gender = widget.gender;
    _profileImage = widget.image;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "name": _nameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "location": _locationController.text,
        "gender": _gender,
        "image": _profileImage,
      });
    }
  }

  Future<void> _changeProfileImage() async {
    final File? selectedImage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectPhotoPage()),
    );

    if (selectedImage != null) {
      setState(() {
        _profileImage = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your name" : null,
              ),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),

              // Phone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  }
                  if (value.length < 10) {
                    return "Phone number must be at least 10 digits";
                  }
                  return null;
                },
              ),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your location" : null,
              ),

              // Gender
              DropdownButtonFormField<String>(
                value: _gender,
                items: ["Male", "Female", "Other"]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _gender = val),
                decoration: const InputDecoration(labelText: "Gender"),
                validator: (value) =>
                    value == null ? "Please select gender" : null,
              ),

              const SizedBox(height: 30),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Submit",
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
