import 'package:flutter/material.dart';
import 'package:home_service_app/service_provider/profile_page/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Worker Side",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WorkerProfilePage(),
    );
  }
}
