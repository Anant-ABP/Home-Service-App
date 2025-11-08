import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/service_provider/home_page/home.dart';
import 'package:home_service_app/service_provider/profile_page/profile_page.dart';

class HistoryPage extends StatelessWidget {
  final int currentIndex;
  final String workerId;

  const HistoryPage({super.key, this.currentIndex = 1, required this.workerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Center(child: Text("History")),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("history")
                  .where("workerId", isEqualTo: workerId)
                  .orderBy("acceptedAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.history, size: 70, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        "No history yet 🙂",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  );
                }

                final historyDocs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: historyDocs.length,
                  itemBuilder: (context, index) {
                    final booking =
                        historyDocs[index].data();
                    final date = booking["acceptedAt"]?.toDate();

                    String formattedDate =
                        "${date.day}-${date.month}-${date.year}";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Show date only when it's the first of this date group
                        if (index == 0 ||
                            formattedDate !=
                                _formatPrevDate(historyDocs[index - 1].data()))
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                        Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${booking["firstName"]} ${booking["lastName"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(booking["description"] ?? ""),
                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(booking["address"] ?? ""),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 18),
                                    const SizedBox(width: 6),
                                    Text(booking["mobile"] ?? ""),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Bottom Nav Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          final pages = [
            HomePage(currentIndex: 0, workerId: workerId),
            HistoryPage(currentIndex: 1, workerId: workerId),
            WorkerProfilePage(currentIndex: 2, workerId: workerId),
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
}

/// ✅ Helper method
String _formatPrevDate(Map<String, dynamic> booking) {
  final date = booking["acceptedAt"]?.toDate();
  return "${date.day}-${date.month}-${date.year}";
}
