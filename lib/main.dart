import 'package:flutter/material.dart';
import 'package:home_service_app/worker/profile/worker_profile.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: Text("Hello World")));
  }
}
