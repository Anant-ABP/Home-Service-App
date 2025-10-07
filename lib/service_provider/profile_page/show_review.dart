import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String selectedFilter = "All";
  int reviewsToShow = 5;

  // Dummy review data
  final List<Map<String, dynamic>> reviews = [
    {
      "rating": 4,
      "title": "Good",
      "text":
          "This worker is good and did his work well but takes so much time to do tasks. Also, he charges too much for simple work.",
    },
    {
      "rating": 3,
      "title": "Decent",
      "text":
          "Ngl it was my decent experience with this dude and he has experience no cap but still I don’t recommend this.",
    },
    {
      "rating": 2,
      "title": "Not Bad",
      "text":
          "This worker is so lazy and uses cheap quality products and also takes too much time for a simple work.",
    },
    {
      "rating": 1,
      "title": "Terrible",
      "text":
          "My experience with this worker is not good. He’s very rude and even charges more money. Can’t recommend this one.",
    },
    {
      "rating": 5,
      "title": "Excellent",
      "text":
          "Amazing worker! Very professional, quick and worth the money. Highly recommended.",
    },
    {
      "rating": 4,
      "title": "Good",
      "text":
          "Satisfied with the service. Could improve speed but overall decent.",
    },
  ];

  List<String> filters = ["All", "1", "2", "3", "4", "5"];

  @override
  Widget build(BuildContext context) {
    // Apply filter
    List<Map<String, dynamic>> filteredReviews = selectedFilter == "All"
        ? reviews
        : reviews
              .where((r) => r["rating"].toString() == selectedFilter)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
            ); // so basically when i will click on back button it will go to previous page
          },
        ),
      ),
      body: Column(
        children: [
          // Filter row
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
                    setState(() {
                      selectedFilter = f;
                      reviewsToShow = 5; // reset when filter changes
                    });
                  },
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: filters.length,
            ),
          ),

          const SizedBox(height: 8),

          // Reviews list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount:
                  (filteredReviews.length > reviewsToShow
                      ? reviewsToShow
                      : filteredReviews.length) +
                  1,
              itemBuilder: (context, index) {
                if (index <
                    (filteredReviews.length > reviewsToShow
                        ? reviewsToShow
                        : filteredReviews.length)) {
                  final r = filteredReviews[index];
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
                                "${r["rating"]}.0 · ${r["title"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(r["text"], style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.thumb_up, size: 16),
                                label: const Text("Helpful for 4"),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.thumb_down, size: 18),
                              const SizedBox(width: 4),
                              const Text("2", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  if (filteredReviews.length > reviewsToShow) {
                    return Center(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            reviewsToShow += 5;
                          });
                        },
                        child: const Text("Load More Reviews"),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
