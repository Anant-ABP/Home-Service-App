import 'package:flutter/material.dart';

class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({super.key});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  int _selectedIndex = 2; // default Profile tab

  double _scale(BuildContext context) {
    final baseWidth = 393.0;
    return MediaQuery.of(context).size.width / baseWidth;
  }

  Widget _ratingStars(double rating, double scale) {
    final int full = rating.floor();
    final bool half = (rating - full) >= 0.5;
    return Row(
      children: [
        for (int i = 0; i < full; i++)
          Icon(Icons.star, size: 14 * scale, color: Colors.amber),
        if (half) Icon(Icons.star_half, size: 14 * scale, color: Colors.amber),
        for (int i = 0; i < (5 - full - (half ? 1 : 0)); i++)
          Icon(Icons.star_border, size: 14 * scale, color: Colors.amber),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = _scale(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 12 * s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                        child: Text(
                          'S',
                          style: TextStyle(
                            fontSize: 28 * s,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12 * s),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service Provider',
                              style: TextStyle(
                                fontSize: 18 * s,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6 * s),
                            Text(
                              'Plumbing • Electrical • Appliances',
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Open reviews (not yet implemented)',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'View Reviews',
                                    style: TextStyle(fontSize: 12 * s),
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

              // Business Info
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
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.phone),
                        title: const Text('Phone Number'),
                        subtitle: const Text('+91 98765 43210'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.mail_outline),
                        title: const Text('Email'),
                        subtitle: const Text('service@example.com'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.location_on_outlined),
                        title: const Text('Location'),
                        subtitle: const Text('Mumbai, India'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Gender'),
                        subtitle: const Text('Male'),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12 * s),

              // Additional Details
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
                    ListTile(
                      leading: const Icon(Icons.build),
                      title: const Text('Manage Services'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Open Services (not implemented yet)',
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.event_available_outlined),
                      title: const Text('Availability'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Open Availability (not implemented yet)',
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit Profile'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PlaceholderPage(
                              title: 'Edit Profile (placeholder)',
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout_outlined),
                      title: const Text('Log Out'),
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Logged out')),
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

      // Bottom navigation bar (no Settings tab now)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'History',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(child: Text('This is a placeholder for $title')),
    );
  }
}
