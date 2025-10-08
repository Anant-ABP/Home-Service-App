import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    "Painting",
    "Gardening",
    "Moving",
    "Laundry",
  ];

  final Map<String, bool> _serviceSelected = {};

  @override
  void initState() {
    super.initState();
    _loadSelectedServices();
  }

  // Load selected services from SharedPreferences
  Future<void> _loadSelectedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final savedServices =
        prefs.getStringList('selected_services') ?? []; // ✅ fixed key
    setState(() {
      for (var service in _services) {
        _serviceSelected[service] = savedServices.contains(service);
      }
    });
  }

  // Save selected services to SharedPreferences
  Future<void> _saveSelectedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedServices = _serviceSelected.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    await prefs.setStringList(
      'selected_services',
      selectedServices,
    ); // ✅ fixed key
  }

  void _submitServices() async {
    await _saveSelectedServices();
    final selectedServices = _serviceSelected.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    Navigator.pop(context, selectedServices);
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
                  final isOn = _serviceSelected[service] ?? false;

                  return ListTile(
                    title: Text(service, style: const TextStyle(fontSize: 16)),
                    trailing: Switch(
                      value: isOn,
                      onChanged: (value) {
                        setState(() {
                          _serviceSelected[service] = value;
                        });
                      },
                      activeColor: Colors.blueAccent,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitServices,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
