// main.dart
import 'package:flutter/material.dart';
import 'package:kimjib/screens/LoginScreen.dart';
import 'package:kimjib/screens/HomeScreen.dart';
import 'package:kimjib/screens/register_screen.dart';
import 'package:kimjib/screens/slide_initial.dart';
import 'package:kimjib/screens/qr_screening.dart';


void main() {
  runApp(const InsuranceApp());
}

class InsuranceApp extends StatelessWidget {
  const InsuranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ).copyWith(
          primary: Colors.red,
          secondary: Colors.red,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder( // Default border (when not focused)
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder( // Visible before clicking
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder( // Border when focused
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
          labelStyle: TextStyle(color: Colors.grey.shade800),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.red,
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      initialRoute: '/slide',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/slide': (context) => const OnboardingScreen(),
        '/qr': (context) => const QRScannerPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}