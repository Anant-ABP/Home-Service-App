import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF007BFF);
    const Color lightBackground = Color(0xFFF7F9FB);

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
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
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryBlue,
                  child: Text(
                    "JAY",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Jay Surani",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "jay180@gmail.com",
                  style: TextStyle(color: Colors.grey),
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
                      "A. Personal Information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Divider(),
                    infoRow(Icons.phone, "Phone Number", "+91 123-234-2342"),
                    infoRow(Icons.email, "Email", "jay180@gmail.com"),
                    infoRow(Icons.home, "Address", "Rajkot, Gujarat"),
                    infoRow(Icons.male, "Gender", "Male"),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit-profile');
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Preferences Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "B. Preferences",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Divider(),
                    Text("Preferred Service time"),
                    SizedBox(height: 8),
                    Text("Any time between 9am - 5pm"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            TextButton.icon(
              onPressed: () {
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
