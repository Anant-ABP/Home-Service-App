import 'package:flutter/material.dart';
// import 'package:get/get_core/get_core.dart';
import 'package:get/get.dart';
import 'package:home_service_app/user/Home_screen.dart';

// ---------------------------------------------------------------- //
// 2. CONFIRMATION SCREEN
// ---------------------------------------------------------------- //

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        //automaticallyMute: false, // Hide back button for confirmation
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          // Puts content in the center vertically
          mainAxisAlignment: MainAxisAlignment.center,
          // Stretches children horizontally
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your booking is confirmed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Thank you for booking with us. We look forward to seeing you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 80),

            // Back to Home Button
            ElevatedButton(
              onPressed: () {
                // Navigate back to the very first screen (BookingScreen in this case)
                // This will clear the navigation stack up to the first route
                Get.to(HomeScreen());
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Back to Home', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
