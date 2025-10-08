import 'package:flutter/material.dart';
import 'package:home_service_app/service_provider/login%20&%20sign%20up/choice_page.dart';
import 'package:home_service_app/service_provider/login%20&%20sign%20up/loginpage.dart';
import 'signup/login_page.dart';
import 'signup/signup_page.dart';
import 'signup/forgot_password_page.dart';
import 'signup/splash_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // Start with Splash Screen
      home: const SplashScreen(),

      // Define routes
      routes: {
        '/choice': (context) => const ChoicePage(),
        '/login': (context) => const LoginPage(),
        '/worker-login': (context) => const WorkerLoginPage(),
        '/signup': (context) => const SignupPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
      },
    );
  }
}
