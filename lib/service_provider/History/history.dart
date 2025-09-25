import 'package:flutter/material.dart';
import 'package:home_service_app/service_provider/home_page/home.dart';
import 'package:home_service_app/service_provider/profile_page/profile_page.dart';

class HistoryPage extends StatelessWidget {
  final int currentIndex;
  const HistoryPage({super.key, this.currentIndex = 1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.history),
            SizedBox(width: 8),
            Text("History"),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            Center(
              child: const Text(
                "Check and manage your services",
                style: TextStyle(
                  color: Color.fromARGB(255, 93, 93, 93),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date Row
            Row(
              children: const [
                Icon(Icons.access_time, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "July 23, 2025",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // History Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with name + time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Jhon Suuper",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "July 23, 11:23 AM",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Job description
                    const Text(
                      "want to paint my living room and bedroom walls. "
                      "Walls are currently blue, want to change to white",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),

                    // Address
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "13 main street, LA farm",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Phone
                    Row(
                      children: const [
                        Icon(Icons.phone, size: 18, color: Colors.grey),
                        SizedBox(width: 6),
                        Text(
                          "+91 123-422-2414",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Completed",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: Colors.blue),
            label: "History",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
