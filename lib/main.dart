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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssets();
    });
  }

  Future<void> _loadAssets() async {
    // 1. CRITICAL: Only wait for the first Hero image (hotel.jpg)
    try {
      await precacheImage(const AssetImage('assets/image/hotel.jpg'), context);
    } catch (e) {
      debugPrint("Warning: Failed to load hero image.");
    }

    // 2. BACKGROUND: Trigger loading for others, but DO NOT await them.
    // This allows the app to open immediately while these load in the back.
    _preloadBackgroundImages();

    // 3. Navigate immediately
    if (mounted) {
      // Small delay to prevent flicker if image loads instantly
      await Future.delayed(const Duration(milliseconds: 100)); 
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  void _preloadBackgroundImages() {
    final images = [
      'assets/image/rental.jpg',
      'assets/image/dorm.jpg',
      'assets/image/home.jpg',
      'assets/image/basement.jpg',
      'assets/image/city.jpg',
      'assets/image/social.jpg',
      'assets/image/human.jpg',
      'assets/image/crime.jpg',
      'assets/image/explode.jpg',
      'assets/image/clamp.jpg',
    ];

    for (String path in images) {
      try {
        precacheImage(AssetImage(path), context);
      } catch (e) {
        debugPrint("Background load failed for $path");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      ),
    );
  }
}