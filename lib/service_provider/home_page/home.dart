import 'package:flutter/material.dart';
import 'package:home_service_app/service_provider/History/history.dart';
import 'package:home_service_app/service_provider/profile_page/profile_page.dart';

class HomePage extends StatefulWidget {
  final int currentIndex;
  const HomePage({super.key, this.currentIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> jobRequests = [
    {
      "name": "Jhon Suuper",
      "date": "July 23, 11:23 AM",
      "description":
          "Want to paint my living room and bedroom walls. Walls are currently blue, want to change to white.",
      "location": "13 Main Street, LA Farm",
      "phone": "+91 123-422-2414",
      "price": "₹70-100",
    },
    {
      "name": "Aizen Sosuke",
      "date": "July 26, 10:22 AM",
      "description":
          "Want to repair my tap, it’s leaking continuously, current tap is from Osaka's company.",
      "location": "123 Pine Wood, near Mount Chiliad",
      "phone": "+91 142-646-7986",
      "price": "₹20-40",
    },
    {
      "name": "Ichigo Kurosaki",
      "date": "July 28, 01:45 PM",
      "description":
          "Need help to install a new ceiling fan in my bedroom. Old wiring may need fixing too.",
      "location": "45 Cherry Blossom Road",
      "phone": "+91 987-654-3210",
      "price": "₹50-80",
    },
  ];

  List<Map<String, String>> schedules = [
    {
      "name": "Jhon Suuper",
      "date": "July 23, 2025 - 11:23 AM",
      "description":
          "Want to paint my living room and bedroom walls. Walls are currently blue, want to change to white.",
      "location": "13 Main Street, LA Farm",
      "phone": "+91 123-422-2414",
    },
  ];

  bool _showAllRequests = false;

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      jobRequests = List.from(jobRequests.reversed);
      schedules = List.from(schedules.reversed);
    });
  }

  void _removeJobRequest(int index) {
    setState(() => jobRequests.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final visibleRequests = _showAllRequests
        ? jobRequests
        : jobRequests.take(2).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: const Text('Home')),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              children: [
                const Text(
                  "Welcome Back,\nService Provider",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Manage your service request and grow your business",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                _sectionTitle(
                  icon: Icons.work_outline,
                  title: "New Job Request (${jobRequests.length})",
                ),
                const SizedBox(height: 12),

                // Job Requests List
                ...visibleRequests.asMap().entries.map((entry) {
                  final index = entry.key;
                  final job = entry.value;
                  return _JobCard(
                    name: job["name"]!,
                    date: job["date"]!,
                    description: job["description"]!,
                    location: job["location"]!,
                    phone: job["phone"]!,
                    price: job["price"]!,
                    onDecline: () => _removeJobRequest(index),
                  );
                }),

                // View All / View Less
                if (jobRequests.length > 2)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.05),
                        border: Border.all(color: Colors.blueAccent, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero, // ✅ prevents oversized button
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // ✅ tighter tap area
                        ),
                        onPressed: () => setState(
                          () => _showAllRequests = !_showAllRequests,
                        ),
                        child: Text(
                          _showAllRequests ? "View Less" : "View All",
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                _sectionTitle(icon: Icons.schedule, title: "My Schedule"),
                const SizedBox(height: 12),

                ...schedules.map(
                  (s) => _ScheduleCard(
                    name: s["name"]!,
                    date: s["date"]!,
                    description: s["description"]!,
                    location: s["location"]!,
                    phone: s["phone"]!,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        selectedItemColor: Colors.blue, // ✅ selected icon & label color
        unselectedItemColor: Colors.grey, // ✅ unselected color
        onTap: (index) {
          if (index == widget.currentIndex) return;
          final pages = [
            const HomePage(currentIndex: 0),
            const HistoryPage(currentIndex: 1),
            const WorkerProfilePage(currentIndex: 2),
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

  Widget _sectionTitle({required IconData icon, required String title}) => Row(
    children: [
      Icon(icon, color: Colors.blue),
      const SizedBox(width: 8),
      Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

class _JobCard extends StatelessWidget {
  final String name, date, description, location, phone, price;
  final VoidCallback onDecline;

  const _JobCard({
    required this.name,
    required this.date,
    required this.description,
    required this.location,
    required this.phone,
    required this.price,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          _infoRow(Icons.location_on, location),
          _infoRow(Icons.phone, phone),
          _infoRow(Icons.attach_money, price),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Accepted $name"))),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  "Accept",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onDecline,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text("Decline"),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  static Widget _infoRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey),
      const SizedBox(width: 4),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
    ],
  );
}

class _ScheduleCard extends StatelessWidget {
  final String name, date, description, location, phone;
  const _ScheduleCard({
    required this.name,
    required this.date,
    required this.description,
    required this.location,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          _infoRow(Icons.location_on, location),
          _infoRow(Icons.phone, phone),
        ],
      ),
    ),
  );

  static Widget _infoRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey),
      const SizedBox(width: 4),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
    ],
  );
}
