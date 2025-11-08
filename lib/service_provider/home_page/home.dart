import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/service_provider/History/history.dart';
import 'package:home_service_app/service_provider/profile_page/profile_page.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

class HomePage extends StatefulWidget {
  final int currentIndex;
  final String workerId;
  // ✅ Required workerId

  const HomePage({super.key, this.currentIndex = 0, required this.workerId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class BookingActions {
  // Method to send SMS notification
  Future<void> sendBookingUpdateToUser({
    required String userPhoneNumber,
    required String workerName,
    required String serviceType,
    required String status, // "accepted" or "declined"
  }) async {
    final message = _buildMessage(workerName, serviceType, status);
    final smsUrl = "sms:$userPhoneNumber?body=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(smsUrl))) {
      await launchUrl(Uri.parse(smsUrl));
    } else {
      print("Could not launch SMS app");
      // Fallback: You can store the notification in Firestore for in-app display
    }
  }

  String _buildMessage(String workerName, String serviceType, String status) {
    if (status == "accepted") {
      return "Hello! $workerName has ACCEPTED your $serviceType service request. They will contact you shortly for further details.";
    } else {
      return "Hello! $workerName has DECLINED your $serviceType service request. Please try booking another service provider.";
    }
  }
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;

    print("✅ Worker Logged In → workerId: ${widget.workerId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Center(child: Text("Home")),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Back,\nService Provider",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              const Text(
                "Manage your service request and grow your business",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              Row(
                children: const [
                  Icon(Icons.work_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "New Job Request",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// ✅ REALTIME FIREBASE STREAM (WITH ERROR HANDLING)
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("bookings")
                    .where("workerId", isEqualTo: widget.workerId)
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("🔥 FIREBASE STREAM ERROR → ${snapshot.error}");
                    return const Text(
                      "⚠️ Error loading data. Check Firestore Index.",
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(child: Text("No job request yet 🙂")),
                    );
                  }

                  final requests = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final booking = requests[index].data();

                      return _JobCard(
                        requestId: requests[index].id, // ✅ document id
                        workerId: widget.workerId, // ✅ pass workerId
                        name:
                            "${booking["firstName"] ?? ""} ${booking["lastName"] ?? ""}",
                        date: booking["timestamp"] != null
                            ? booking["timestamp"].toDate().toString()
                            : "Date not available",
                        description:
                            booking["description"] ?? "No description provided",
                        location: booking["address"] ?? "Address not provided",
                        phone: booking["mobile"] ?? "Phone not provided",
                        onDecline: () {
                          FirebaseFirestore.instance
                              .collection("bookings")
                              .doc(requests[index].id)
                              .delete();
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == _currentIndex) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => [
                HomePage(currentIndex: 0, workerId: widget.workerId),
                HistoryPage(currentIndex: 1, workerId: widget.workerId),
                WorkerProfilePage(currentIndex: 2, workerId: widget.workerId),
              ][index],
            ),
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

// ✅ CARD UI CREATED HERE — INDEPENDENT OF FIREBASE

class _JobCard extends StatelessWidget {
  final String requestId;
  final String workerId;
  final String? name, date, description, location, phone;
  final VoidCallback onDecline;

  const _JobCard({
    required this.requestId,
    required this.workerId,
    required this.name,
    required this.date,
    required this.description,
    required this.location,
    required this.phone,
    required this.onDecline,
  });

  // Method to send SMS notification
  Future<void> _sendBookingUpdateToUser({
    required String userPhoneNumber,
    required String workerName,
    required String serviceType,
    required String status, // "accepted" or "declined"
  }) async {
    final message = _buildMessage(workerName, serviceType, status);
    final smsUrl = "sms:$userPhoneNumber?body=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(smsUrl))) {
      await launchUrl(Uri.parse(smsUrl));
      print("📱 SMS app launched for $status notification");
    } else {
      print("❌ Could not launch SMS app");
    }
  }

  String _buildMessage(String workerName, String serviceType, String status) {
    if (status == "accepted") {
      return "Hello! $workerName has ACCEPTED your service request. They will contact you shortly for further details. Service: $serviceType";
    } else {
      return "Hello! $workerName has DECLINED your service request. Please try booking another service provider. Service: $serviceType";
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            date ?? "",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(description ?? "", style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 10),
          _info(Icons.location_on_outlined, location ?? ""),
          _info(Icons.phone, phone ?? ""),
          const SizedBox(height: 10),

          Row(
            children: [
              // ACCEPT BUTTON
              ElevatedButton(
                onPressed: () async {
                  try {
                    // 1. Get the booking data first
                    final docSnapshot = await FirebaseFirestore.instance
                        .collection("bookings")
                        .doc(requestId)
                        .get();

                    if (!docSnapshot.exists) return;

                    final data = docSnapshot.data()!;

                    // 2. Get worker name for SMS
                    final workerDoc = await FirebaseFirestore.instance
                        .collection("workers")
                        .doc(workerId)
                        .get();

                    final workerName =
                        workerDoc.data()?["name"] ?? "Service Provider";

                    // 3. Send SMS notification to user
                    if (phone != null && phone!.isNotEmpty) {
                      await _sendBookingUpdateToUser(
                        userPhoneNumber: phone!,
                        workerName: workerName,
                        serviceType: description ?? "Home Service",
                        status: "accepted",
                      );
                    }

                    // 4. Move to history
                    await FirebaseFirestore.instance.collection("history").add({
                      "workerId": workerId,
                      "firstName": data["firstName"] ?? "",
                      "lastName": data["lastName"] ?? "",
                      "description": data["description"] ?? "",
                      "mobile": data["mobile"] ?? "",
                      "address": data["address"] ?? "",
                      "acceptedAt": FieldValue.serverTimestamp(),
                      "status": "accepted", // Add status to history
                    });

                    // 5. Remove from bookings
                    await FirebaseFirestore.instance
                        .collection("bookings")
                        .doc(requestId)
                        .delete();

                    print("✅ Booking accepted and SMS sent");
                  } catch (e) {
                    print("❌ Error accepting booking: $e");
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Accept"),
              ),

              const SizedBox(width: 10),

              // DECLINE BUTTON
              OutlinedButton(
                onPressed: () async {
                  try {
                    // 1. Get the booking data first
                    final docSnapshot = await FirebaseFirestore.instance
                        .collection("bookings")
                        .doc(requestId)
                        .get();

                    if (!docSnapshot.exists) return;

                    final data = docSnapshot.data()!;

                    // 2. Get worker name for SMS
                    final workerDoc = await FirebaseFirestore.instance
                        .collection("workers")
                        .doc(workerId)
                        .get();

                    final workerName =
                        workerDoc.data()?["name"] ?? "Service Provider";

                    // 3. Send SMS notification to user
                    if (phone != null && phone!.isNotEmpty) {
                      await _sendBookingUpdateToUser(
                        userPhoneNumber: phone!,
                        workerName: workerName,
                        serviceType: description ?? "Home Service",
                        status: "declined",
                      );
                    }

                    // 4. Optional: Add to history as declined
                    await FirebaseFirestore.instance.collection("history").add({
                      "workerId": workerId,
                      "firstName": data["firstName"] ?? "",
                      "lastName": data["lastName"] ?? "",
                      "description": data["description"] ?? "",
                      "mobile": data["mobile"] ?? "",
                      "address": data["address"] ?? "",
                      "declinedAt": FieldValue.serverTimestamp(),
                      "status": "declined",
                    });

                    // 5. Remove from bookings (original onDecline functionality)
                    onDecline();

                    print("❌ Booking declined and SMS sent");
                  } catch (e) {
                    print("❌ Error declining booking: $e");
                  }
                },
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

  static Widget _info(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
