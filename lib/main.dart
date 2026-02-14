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
    // FIX: Wait for the first frame to be rendered before starting async work.
    // This prevents "Navigator locked" and "setState during build" errors.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssets();
    });
  }

  Future<void> _loadAssets() async {
    // List of all critical images to preload
    final images = [
      'assets/image/hotel.jpg',
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

    // Attempt to preload images
    for (String path in images) {
      try {
        await precacheImage(AssetImage(path), context);
      } catch (e) {
        // Log error but continue so the app doesn't freeze
        debugPrint("Warning: Failed to load image $path. Check pubspec.yaml.");
      }
    }

    // FIX: Ensure a minimal delay so the Splash Screen is actually seen
    // and to ensure the Navigator is ready to accept new routes.
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
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