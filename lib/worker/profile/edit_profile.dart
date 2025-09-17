import 'package:flutter/material.dart';
import 'package:home_service_app/worker/profile/worker_profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for fields
  final TextEditingController _nameController = TextEditingController(
    text: "Service Provider",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "service@mail.com",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "+91 9876543210",
  );
  final TextEditingController _locationController = TextEditingController(
    text: "City, Country",
  );
  final TextEditingController _aboutController = TextEditingController(
    text: "Experienced in multiple services...",
  );

  // Function to go back to Profile Page
  void _goToProfile() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WorkerProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goToProfile, // ✅ Back to Profile
        ),
        title: const Text("Edit Profile"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _aboutController,
                decoration: const InputDecoration(labelText: "About"),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // ✅ Redirect to Profile Page
                    _goToProfile();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
