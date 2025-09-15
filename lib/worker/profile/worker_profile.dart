import 'package:flutter/material.dart';

class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({super.key});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  // Example state: active bottom nav index
  int _selectedIndex = 2;

  // Helper to scale UI from baseline (393 x 865)
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
              // Header Card with avatar, name, rating
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12 * s)),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(12 * s),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32 * s,
                        backgroundColor: Colors.blueAccent,
                        child: Text('S', style: TextStyle(fontSize: 28 * s, color: Colors.white)),
                      ),
                      SizedBox(width: 12 * s),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Service Provider',
                                style: TextStyle(fontSize: 18 * s, fontWeight: FontWeight.w600)),
                            SizedBox(height: 6 * s),
                            Text('Plumbing • Electrical • Appliances',
                                style: TextStyle(fontSize: 13 * s, color: Colors.grey[700])),
                            SizedBox(height: 8 * s),
                            Row(
                              children: [
                                _ratingStars(4.6, s),
                                SizedBox(width: 8 * s),
                                Text('4.6', style: TextStyle(fontSize: 13 * s)),
                                const Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 6 * s),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8 * s)),
                                  ),
                                  onPressed: () {
                                    // Placeholder: view reviews page will be step 5
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Open reviews (not yet implemented)')),
                                    );
                                  },
                                  child: Text('View Reviews', style: TextStyle(fontSize: 12 * s)),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12 * s),

              // Business Info card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12 * s)),
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 8 * s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Business Information', style: TextStyle(fontSize: 15 * s, fontWeight: FontWeight.w600)),
                      SizedBox(height: 6 * s),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.phone),
                        title: const Text('Phone Number'),
                        subtitle: const Text('+91 98765 43210'),
                        onTap: () {},
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.mail_outline),
                        title: const Text('Email'),
                        subtitle: const Text('service@example.com'),
                        onTap: () {},
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.location_on_outlined),
                        title: const Text('Location'),
                        subtitle: const Text('Mumbai, India'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12 * s),

              // Preferences / Quick info
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12 * s)),
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 10 * s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profile Details', style: TextStyle(fontSize: 15 * s, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8 * s),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.person_outline),
                                SizedBox(width: 8 * s),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Gender', style: TextStyle(fontSize: 12 * s, color: Colors.grey[700])),
                                    SizedBox(height: 2 * s),
                                    Text('Male', style: TextStyle(fontSize: 14 * s)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.language_outlined),
                                SizedBox(width: 8 * s),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Languages', style: TextStyle(fontSize: 12 * s, color: Colors.grey[700])),
                                    SizedBox(height: 2 * s),
                                    Text('English, Hindi', style: TextStyle(fontSize: 14 * s)),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 14 * s),

              // Actions list
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12 * s)),
                elevation: 0,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.build),
                      title: const Text('Manage Services'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Step for Services page will be provided later
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open Services (not implemented yet)')));
                      },
                    ),
                    Divider(height: 1 * s),
                    ListTile(
                      leading: const Icon(Icons.event_available_outlined),
                      title: const Text('Availability'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open Availability (not implemented yet)')));
                      },
                    ),
                    Divider(height: 1 * s),
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit Profile'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // For now we push a temporary placeholder page to avoid navigation errors
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PlaceholderPage(title: 'Edit Profile (placeholder)')),
                        );
                      },
                    ),
                    Divider(height: 1 * s),
                    ListTile(
                      leading: const Icon(Icons.logout_outlined),
                      title: const Text('Log Out'),
                      onTap: () {
                        // handle logout
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Log out'),
                            content: const Text('Are you sure you want to log out?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                              TextButton(onPressed: () {
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
                              }, child: const Text('Yes')),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24 * s),

              // Optional: small analytics / completion section similar to design
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12 * s),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10 * s),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6 * s, offset: Offset(0, 2 * s))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Profile Completion', style: TextStyle(fontSize: 13 * s, fontWeight: FontWeight.w600)),
                          SizedBox(height: 8 * s),
                          LinearProgressIndicator(value: 0.86),
                          SizedBox(height: 6 * s),
                          Text('86% complete', style: TextStyle(fontSize: 12 * s, color: Colors.grey[700])),
                        ],
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 24 * s),
            ],
          ),
        ),
      ),