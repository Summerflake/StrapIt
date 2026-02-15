import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

void main() {
  runApp(const StrapitApp());
}

class StrapitApp extends StatelessWidget {
  const StrapitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Strapit - Secure Anywhere',
      theme: ThemeData(
        brightness: Brightness.light, 
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // 1. ONLY precache the very first image user sees (The Hero Image).
    // This reduces initial data load by ~90%.
    try {
      await precacheImage(const AssetImage('assets/image/hotel.jpg'), context);
    } catch (e) {
      debugPrint("Error precaching hero image: $e");
    }

    // 2. Navigate immediately after the first image is ready.
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionDuration: Duration.zero, // Instant switch, no animation lag
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Simple loading indicator while fetching the first image
        child: CircularProgressIndicator(color: Colors.blueAccent),
      ),
    );
  }
}