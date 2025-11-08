import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_service_app/bookings/Personal_Info.dart';

class AcScreen extends StatelessWidget {
  const AcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We’ll match a few common labels so minor naming differences still work.
    const acLabels = [
      "AC",
      "Ac repair",
      "AC Repair",
      "AC Service",
      "Air Conditioning",
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('AC Repair'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("workers")
            // tolerate different spellings/cases
            .where("providerServices", arrayContainsAny: acLabels)
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
                "No AC technicians available right now",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final workers = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final data = workers[index].data();

              final name = (data["name"] ?? "Service Provider") as String;
              final avatarUrl = (data["profileImage"] ?? "") as String?;
              final rating = (data["rating"] ?? 0).toDouble();
              final reviews = (data["reviews"] ?? 0) is int
                  ? data["reviews"] as int
                  : int.tryParse("${data["reviews"]}") ?? 0;

              return WorkerCompactCard(
                name: name,
                title: "AC Service",
                avatarUrl: avatarUrl,
                rating: rating,
                reviewCount: reviews,
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

/// Compact, reusable worker card (no big banner image, no price)
class WorkerCompactCard extends StatelessWidget {
  final String name;
  final String title;
  final String? avatarUrl;
  final double rating;
  final int reviewCount;
  final VoidCallback onBook;

  const WorkerCompactCard({
    super.key,
    required this.name,
    required this.title,
    required this.avatarUrl,
    required this.rating,
    required this.reviewCount,
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
            // top row: avatar + name + Book
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

            // service title
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

            // rating row
            Row(
              children: [
                _Stars(rating: rating),
                const SizedBox(width: 10),
                Text(
                  "($reviewCount Reviews)",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating;
  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    final safe = rating.isNaN ? 0.0 : rating;
    final full = safe.clamp(0, 5).floor();
    final half = (safe - full) >= 0.5;
    final empty = 5 - full - (half ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < full; i++)
          const Icon(Icons.star, size: 18, color: Colors.black87),
        if (half) const Icon(Icons.star_half, size: 18, color: Colors.black87),
        for (int i = 0; i < empty; i++)
          const Icon(Icons.star_border, size: 18, color: Colors.black54),
      ],
    );
  }
}
