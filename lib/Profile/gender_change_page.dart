import 'package:flutter/material.dart';

class GenderChangePage extends StatefulWidget {
  const GenderChangePage({super.key});

  @override
  State<GenderChangePage> createState() => _GenderChangePageState();
}

class _GenderChangePageState extends State<GenderChangePage> {
  String selectedGender = "Male";

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF007BFF);
    const Color lightBackground = Color(0xFFF7F9FB);

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text("Gender Change"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Select Gender",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                RadioListTile<String>(
                  title: const Text("Male"),
                  value: "Male",
                  groupValue: selectedGender,
                  activeColor: primaryBlue,
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text("Female"),
                  value: "Female",
                  groupValue: selectedGender,
                  activeColor: primaryBlue,
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text("Others"),
                  value: "Others",
                  groupValue: selectedGender,
                  activeColor: primaryBlue,
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Save",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}