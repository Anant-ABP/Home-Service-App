import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_service_app/bookings/Personal_Info.dart';

class ElectricianScreen extends StatelessWidget {
  const ElectricianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text("Electrician"),
        centerTitle: true,
        elevation: 0.5,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("workers")
            .where("providerServices", arrayContains: "Electrical")
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No electricians available right now",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final workers = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final w = workers[index].data();

              return WorkerCompactCard(
                name: w["name"] ?? "Service Provider",
                title: "Electrical Service",
                avatarUrl: w["profileImage"],
                location: w["location"] ?? "Location not available",
                phone: w["phone"] ?? "Phone not available",
                onBook: () =>
                    Get.to(() => InfoFormPage(workerId: workers[index].id)),
              );
            },
          );
        },
      ),
    );
  }
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

/// Reusable compact worker card with location and phone
class WorkerCompactCard extends StatelessWidget {
  final String name;
  final String title;
  final String? avatarUrl;
  final String location;
  final String phone;
  final VoidCallback onBook;

  const WorkerCompactCard({
    super.key,
    required this.name,
    required this.title,
    required this.avatarUrl,
    required this.location,
    required this.phone,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Avatar + Name + Book button
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: _getProfileImage(avatarUrl),
                  backgroundColor: Colors.blue.shade300,
                  child: (avatarUrl == null || avatarUrl!.isEmpty)
                      ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : "W",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: onBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.black12.withOpacity(0.15)),
                    ),
                  ),
                  child: const Text("Book"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Service Title
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),

            const SizedBox(height: 8),

            // location and phone info
            _InfoRow(icon: Icons.location_on_outlined, text: location),
            const SizedBox(height: 4),
            _InfoRow(icon: Icons.phone, text: phone),
          ],
        ),
      ),
    );
  }
}

// Helper widget for location and phone rows
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
