import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String selectedFilter = "All";

  List<String> filters = ["All", "1", "2", "3", "4", "5"];

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid; // Worker UID

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 45,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                String f = filters[index];
                bool isSelected = selectedFilter == f;
                return ChoiceChip(
                  label: Text(f == "All" ? "All" : "$f ★"),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => selectedFilter = f);
                  },
                  selectedColor: Colors.blueAccent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: filters.length,
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("workers")
                  .doc(uid)
                  .collection("reviews")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No reviews yet",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                // Convert Firestore docs to list of reviews
                final reviews = snapshot.data!.docs;

                // Apply filter
                final filtered = selectedFilter == "All"
                    ? reviews
                    : reviews
                          .where(
                            (r) => (r["rating"]).toString() == selectedFilter,
                          )
                          .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final r = filtered[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < r["rating"]
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${r["rating"]}.0",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Review Title
                            Text(
                              r["title"],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Review Text
                            Text(
                              r["text"],
                              style: const TextStyle(fontSize: 13),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                const Icon(Icons.person, size: 15),
                                const SizedBox(width: 6),
                                Text(
                                  r["userName"] ?? "Anonymous",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
