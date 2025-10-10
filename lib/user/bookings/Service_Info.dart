import 'package:flutter/material.dart';
import 'Confirm.dart';
//import 'package:intl/intl.dart'; // Import for date formatting

// You will need to add the intl package to your pubspec.yaml:
// dependencies:
//   flutter:
//     sdk: flutter
//   intl: ^0.18.1 // or the latest version

// ---------------------------------------------------------------- //
// 1. BOOKING SCREEN
// ---------------------------------------------------------------- //

 class ServiceInfo_Screen extends StatefulWidget {
  const ServiceInfo_Screen({super.key});

  @override
  State<ServiceInfo_Screen> createState() => _ServiceInfo_ScreenState();
}

class _ServiceInfo_ScreenState extends State<ServiceInfo_Screen> {
  // Form Key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for TextFormFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // State variables for selection
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  // Dummy list of available time slots
  final List<String> _timeSlots = [
    '09:00 AM',
    '10:30 AM',
    '12:00 PM',
    '02:30 PM',
    '04:00 PM',
    '05:30 PM',
  ];

  // Function to show the Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1), // 1 year from now
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
       // _dateController.text = DateFormat('EEEE, MMM d, yyyy').format(picked);
      });
    }
  }

  // Function to handle the booking submission
  void _submitBooking() {
    if (_formKey.currentState!.validate() && _selectedTimeSlot != null) {
      // All fields are valid and time slot is selected
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConfirmationScreen()),
      );
    } else {
      // Show an error for time slot if not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1. Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 2. Date Field (with Date Picker)
              TextFormField(
                controller: _dateController,
                readOnly: true, // Prevents manual text entry
                onTap: () => _selectDate(context), // Show picker on tap
                decoration: const InputDecoration(
                  labelText: 'Select Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 3. Time Slot Section (Using Wrap and ChoiceChip)
              const Text(
                'Select Time Slot:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0, // Gap between chips
                runSpacing: 4.0, // Gap between lines of chips
                children: _timeSlots.map((slot) {
                  return ChoiceChip(
                    label: Text(slot),
                    selected: _selectedTimeSlot == slot,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedTimeSlot = selected ? slot : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // 4. Booking Button
              ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Book Now', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // ---------------------------------------------------------------- //
// // 2. CONFIRMATION SCREEN
// // ---------------------------------------------------------------- //

// class ConfirmationScreen extends StatelessWidget {
//   const ConfirmationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Booking Confirmed'),
//         //automaticallyMute: false, // Hide back button for confirmation
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           // Puts content in the center vertically
//           mainAxisAlignment: MainAxisAlignment.center, 
//           // Stretches children horizontally
//           crossAxisAlignment: CrossAxisAlignment.stretch, 
//           children: <Widget>[
//             const Icon(
//               Icons.check_circle_outline,
//               color: Colors.green,
//               size: 100,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Your booking is confirmed!',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Thank you for booking with us. We look forward to seeing you.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black54,
//               ),
//             ),
//             const SizedBox(height: 80),

//             // Back to Home Button
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate back to the very first screen (BookingScreen in this case)
//                 // This will clear the navigation stack up to the first route
//                 Navigator.of(context).popUntil((route) => route.isFirst);
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 'Back to Home',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }