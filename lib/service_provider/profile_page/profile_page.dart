// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // for base64 encoding/decoding
import '../home_page/home.dart';
import '../History/history.dart';
import 'edit_profile.dart';
import 'manage_services.dart';
import 'availability.dart';
import '../../../signup/login_page.dart';

class WorkerProfilePage extends StatefulWidget {
  final int currentIndex;
  final String workerId;

  const WorkerProfilePage({
    super.key,
    this.currentIndex = 2,
    required this.workerId,
  });

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  List<String> _providerServices = [];
  Map<String, Map<String, String>> _availabilitySummary = {};

  String? _name, _email, _phone, _location, _gender, _imagePath;
  final double _avgRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadServices();
    _loadAvailability();
  }

  double _scale(BuildContext context) =>
      MediaQuery.of(context).size.width / 393;

  ImageProvider _getProfileImage() {
    if (_imagePath == null || _imagePath!.isEmpty) {
      return const AssetImage("assets/default_avatar.png");
    }

    if (_imagePath!.startsWith("http")) {
      return NetworkImage(_imagePath!);
    }

    if (_imagePath!.startsWith("data:image")) {
      // Handle base64 image
      final bytes = base64Decode(_imagePath!.split(',').last);
      return MemoryImage(bytes);
    }

    return const AssetImage("assets/default_avatar.png");
  }

  Future<void> _loadProfile() async {
    try {
      print("🔄 Loading profile for worker: ${widget.workerId}");

      final snap = await FirebaseFirestore.instance
          .collection("workers")
          .doc(widget.workerId)
          .get();

      if (!snap.exists) {
        print("❌ Worker document doesn't exist");
        return;
      }

      final data = snap.data()!;
      print("📄 Retrieved data: $data");

      setState(() {
        _name = data["name"] ?? "";
        _email = data["email"] ?? "";
        _phone = data["phone"] ?? "";
        _location = data["location"] ?? "";
        _gender = data["gender"] ?? "";
        _imagePath = data["profileImage"] ?? "";
      });

      print("🖼️ Image path set to: $_imagePath");
    } catch (e) {
      print("❌ Error loading profile: $e");
    }
  }

  Future<void> _loadServices() async {
    final prefs = await SharedPreferences.getInstance();
    final savedServices = prefs.getStringList('selected_services') ?? [];
    setState(() => _providerServices = savedServices);
  }

  Future<void> _loadAvailability() async {
    final prefs = await SharedPreferences.getInstance();
    final days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    Map<String, Map<String, String>> summary = {};
    for (var day in days) {
      final enabled = prefs.getBool('${day}_enabled') ?? false;
      if (enabled) {
        final start = TimeOfDay(
          hour: prefs.getInt('${day}_startHour') ?? 9,
          minute: prefs.getInt('${day}_startMinute') ?? 0,
        ).format(context);

        final end = TimeOfDay(
          hour: prefs.getInt('${day}_endHour') ?? 17,
          minute: prefs.getInt('${day}_endMinute') ?? 0,
        ).format(context);

        summary[day] = {"start": start, "end": end};
      }
    }

    setState(() => _availabilitySummary = summary);
  }

  @override
  Widget build(BuildContext context) {
    final s = _scale(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Profile')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 12 * s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ PROFILE CARD
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12 * s),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32 * s,
                        backgroundImage: _getProfileImage(),
                      ),

                      SizedBox(width: 12 * s),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _name ?? "Service Provider",
                              style: TextStyle(
                                fontSize: 18 * s,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              _providerServices.isEmpty
                                  ? "No services added"
                                  : _providerServices.join(" • "),
                              style: TextStyle(
                                fontSize: 13 * s,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ✅ BUSINESS INFORMATION CARD
              Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12 * s,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Business Information",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _infoTile(Icons.phone, "Phone Number", _phone ?? ""),
                      _infoTile(Icons.email, "Email", _email ?? ""),
                      _infoTile(Icons.location_on, "Location", _location ?? ""),
                      _infoTile(Icons.person, "Gender", _gender ?? ""),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ✅ ACTION MENU
              Card(
                elevation: 1,
                child: Column(
                  children: [
                    _actionTile(Icons.build, "Manage Services", () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageServicesPage(),
                        ),
                      );
                      _loadServices();
                    }),

                    _actionTile(
                      Icons.event_available,
                      "Availability",
                      () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AvailabilityPage(),
                          ),
                        );
                        _loadAvailability();
                      },
                    ),

                    _actionTile(Icons.edit, "Edit Profile", () async {
                      File? localFile;

                      if (_imagePath != null &&
                          !_imagePath!.startsWith("http")) {
                        localFile = File(_imagePath!);
                      }

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(
                            name: _name,
                            phone: _phone,
                            location: _location,
                            gender: _gender,
                            image: localFile,
                          ),
                        ),
                      );

                      _loadProfile();
                    }),

                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          final pages = [
            HomePage(currentIndex: 0, workerId: widget.workerId),
            HistoryPage(currentIndex: 1, workerId: widget.workerId),
            WorkerProfilePage(currentIndex: 2, workerId: widget.workerId),
          ];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => pages[index]),
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
  );

  Widget _actionTile(IconData icon, String title, VoidCallback onTap) => Column(
    children: [
      ListTile(
        leading: Icon(icon),
        trailing: const Icon(Icons.chevron_right),
        title: Text(title),
        onTap: onTap,
      ),
      const Divider(height: 0),
    ],
  );
}
