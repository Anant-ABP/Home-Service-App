import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_service_app/service_provider/login%20&%20sign%20up/loginpage.dart';
import 'package:home_service_app/service_provider/History/history.dart';
import 'package:home_service_app/service_provider/home_page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'availability.dart';
import 'edit_profile.dart';
import 'manage_services.dart';
import 'show_review.dart';

class WorkerProfilePage extends StatefulWidget {
  final int currentIndex;
  const WorkerProfilePage({super.key, this.currentIndex = 2});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  List<String> _providerServices = [];
  Map<String, Map<String, String>> _availabilitySummary = {};
  String? _name, _email, _phone, _location, _gender, _imagePath;

  @override
  void initState() {
    super.initState();
    _loadServices();
    _loadAvailability();
    _loadProfile();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadServices();
    });
  }

  Future<void> _loadServices() async {
    final prefs = await SharedPreferences.getInstance();
    final savedServices = prefs.getStringList('selected_services') ?? [];

    setState(() {
      _providerServices = savedServices;
    });
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

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("worker_name") ?? "Service Provider";
      _email = prefs.getString("worker_email") ?? "service@example.com";
      _phone = prefs.getString("worker_phone") ?? "+91 98765 43210";
      _location = prefs.getString("worker_location") ?? "Mumbai, India";
      _gender = prefs.getString("worker_gender") ?? "Male";
      _imagePath = prefs.getString("worker_image");
    });
  }

  double _scale(BuildContext context) =>
      MediaQuery.of(context).size.width / 393;

  Widget _ratingStars(double rating, double scale) {
    final full = rating.floor();
    final half = (rating - full) >= 0.5;
    return Row(
      children: [
        for (int i = 0; i < full; i++)
          Icon(Icons.star, size: 14 * scale, color: Colors.amber),
        if (half) Icon(Icons.star_half, size: 14 * scale, color: Colors.amber),
        for (int i = 0; i < 5 - full - (half ? 1 : 0); i++)
          Icon(Icons.star_border, size: 14 * scale, color: Colors.amber),
      ],
    );
  }

  String _availabilityText() {
    if (_availabilitySummary.isEmpty) return "No availability set";
    return _availabilitySummary.entries
        .map(
          (e) =>
              "${e.key.substring(0, 3)}: ${e.value['start']} - ${e.value['end']}",
        )
        .join(" • ");
  }

  Widget _infoTile(IconData icon, String title, String subtitle) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
  );

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) => Column(
    children: [
      ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
      const Divider(height: 1),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final s = _scale(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: const Text('Profile')),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 12 * s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * s),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(12 * s),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32 * s,
                        backgroundColor: Colors.blueAccent,
                        backgroundImage: _imagePath != null
                            ? FileImage(File(_imagePath!))
                            : null,
                        child: _imagePath == null
                            ? Text(
                                (_name?.isNotEmpty == true ? _name![0] : "S")
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 28 * s,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: 12 * s),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _name ?? 'Service Provider',
                              style: TextStyle(
                                fontSize: 18 * s,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6 * s),
                            Text(
                              _providerServices.isEmpty
                                  ? 'No Services Selected'
                                  : _providerServices.join(' • '),
                              style: TextStyle(
                                fontSize: 13 * s,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 6 * s),
                            Text(
                              _availabilityText(),
                              style: TextStyle(
                                fontSize: 13 * s,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8 * s),
                            Row(
                              children: [
                                _ratingStars(4.6, s),
                                SizedBox(width: 8 * s),
                                Text('4.6', style: TextStyle(fontSize: 13 * s)),
                                const Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10 * s,
                                      vertical: 6 * s,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8 * s,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ReviewPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'View Reviews',
                                    style: TextStyle(
                                      fontSize: 12 * s,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12 * s),
              // here is worker business information
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * s),
                ),
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12 * s,
                    vertical: 8 * s,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business Information',
                        style: TextStyle(
                          fontSize: 15 * s,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6 * s),
                      _infoTile(Icons.phone, 'Phone Number', _phone ?? ''),
                      _infoTile(Icons.mail_outline, 'Email', _email ?? ''),
                      _infoTile(
                        Icons.location_on_outlined,
                        'Location',
                        _location ?? '',
                      ),
                      _infoTile(Icons.person_outline, 'Gender', _gender ?? ''),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12 * s),

              // and here is Additional Details
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * s),
                ),
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12 * s,
                        vertical: 10 * s,
                      ),
                      child: Text(
                        'Additional Details',
                        style: TextStyle(
                          fontSize: 15 * s,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    _actionTile(
                      icon: Icons.build,
                      title: 'Manage Services',
                      onTap: () async {
                        final selectedServices = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageServicesPage(),
                          ),
                        );
                        if (selectedServices != null) {
                          setState(
                            () => _providerServices = List<String>.from(
                              selectedServices,
                            ),
                          );
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setStringList(
                            'selected_services',
                            _providerServices,
                          );
                        }
                      },
                    ),
                    _actionTile(
                      icon: Icons.event_available_outlined,
                      title: 'Availability',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AvailabilityPage(),
                          ),
                        );
                        _loadAvailability();
                      },
                    ),

                    // Inside _actionTile for Edit Profile section:
                    _actionTile(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfilePage(
                              name: _name,
                              email: _email,
                              phone: _phone,
                              location: _location,
                              gender: _gender,
                              image: _imagePath != null
                                  ? File(_imagePath!)
                                  : null,
                            ),
                          ),
                        );

                        if (result != null && result is Map) {
                          final prefs = await SharedPreferences.getInstance();

                          await prefs.setString(
                            "worker_name",
                            result["name"] ?? "",
                          );
                          await prefs.setString(
                            "worker_email",
                            result["email"] ?? "",
                          );
                          await prefs.setString(
                            "worker_phone",
                            result["phone"] ?? "",
                          );
                          await prefs.setString(
                            "worker_location",
                            result["location"] ?? "",
                          );
                          await prefs.setString(
                            "worker_gender",
                            result["gender"] ?? "",
                          );
                          if (result["image"] != null) {
                            await prefs.setString(
                              "worker_image",
                              result["image"],
                            );
                          }

                          _loadProfile(); // Refresh UI
                        }
                      },
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Log out'),
                            content: const Text(
                              'Are you sure you want to log out?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WorkerLoginPage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24 * s),
            ],
          ),
        ),
      ),
      // here is Bottom Nav Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          if (index == widget.currentIndex) return;
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(currentIndex: 0),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryPage(currentIndex: 1),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const WorkerProfilePage(currentIndex: 2),
                ),
              );
              break;
          }
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
