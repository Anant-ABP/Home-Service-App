import 'package:flutter/material.dart';
import 'package:home_service_app/service_provider/login%20&%20sign%20up/choice_page.dart';
import 'package:home_service_app/service_provider/login%20&%20sign%20up/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ChoicePage(),
      routes: {'/login': (context) => const LoginPage()},
    );
  }
}
