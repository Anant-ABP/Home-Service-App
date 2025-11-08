import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageServicesPage extends StatefulWidget {
  const ManageServicesPage({super.key});

  @override
  State<ManageServicesPage> createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends State<ManageServicesPage> {
  final List<String> _services = [
    "Plumbing",
    "Electrical",
    "Carpentry",
    "Cleaning",
    "Ac repair",
    "Mechanic",
  ];

  final Map<String, bool> _serviceSelected = {};

  Future<void> _loadFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection("workers")
        .doc(uid)
        .get();

    List<dynamic> firestoreServices =
        doc.data()?["providerServices"] as List? ?? [];

    setState(() {
      for (var service in _services) {
        _serviceSelected[service] = firestoreServices.contains(service);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFromFirestore();
  }

  /// ✅ Save to SharedPreferences + Firestore
  Future<void> _saveSelectedServices() async {
    final prefs = await SharedPreferences.getInstance();

    final selectedServices = _serviceSelected.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key.trim()) // important
        .toList();

    // Save locally
    await prefs.setStringList("selected_services", selectedServices);

    // ✅ MUST BE ARRAY IN FIRESTORE
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("workers").doc(uid).set({
      "providerServices": FieldValue.arrayUnion(selectedServices),
    }, SetOptions(merge: true));
  }

  void _submitServices() async {
    await _saveSelectedServices();
    Navigator.pop(context, true); // Notify parent that refresh is needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Services"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _services.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final service = _services[index];
                  return ListTile(
                    title: Text(service),
                    trailing: Switch(
                      value: _serviceSelected[service] ?? false,
                      onChanged: (value) {
                        setState(() {
                          _serviceSelected[service] = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Bigger Save Button (matches availability page style)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitServices,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
