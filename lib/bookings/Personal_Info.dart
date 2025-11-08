import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_service_app/bookings/confirm.dart';

class InfoFormPage extends StatefulWidget {
  final String workerId; // worker selected by user

  const InfoFormPage({super.key, required this.workerId});

  @override
  State<InfoFormPage> createState() => _InfoFormPageState();
}

class _InfoFormPageState extends State<InfoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController(); // <-- NEW FIELD

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection("bookings").add({
          "workerId": widget.workerId,
          "firstName": _firstNameController.text.trim(),
          "lastName": _lastNameController.text.trim(),
          "mobile": _mobileController.text.trim(),
          "address": _addressController.text.trim(),
          "description": _descriptionController.text.trim(),
          "timestamp": FieldValue.serverTimestamp(),
        });

        Get.offAll(
          () => const ConfirmationScreen(),
        ); // ✅ navigate to confirmation
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to send request: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("✅ INFO FORM OPENED FOR WORKER ID: ${widget.workerId}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Your Information"),
        elevation: 0.5,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: "First Name",
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your first name" : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your last name" : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.length != 10 ? "Enter valid 10-digit mobile" : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Address",
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your address" : null,
              ),
              SizedBox(height: 16),

              // ✅ NEW Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description (Explain your issue)",
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter description" : null,
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Submit Request",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
