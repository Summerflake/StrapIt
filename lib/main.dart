import 'dart:async';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

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
        brightness: Brightness.dark,
        textTheme: GoogleFonts.montserratTextTheme(), // Applied globally
      ),
      home: const MainLandingPage(),
    );
  }
}

class MainLandingPage extends StatefulWidget {
  const MainLandingPage({super.key});

  @override
  State<MainLandingPage> createState() => _MainLandingPageState();
}

class _MainLandingPageState extends State<MainLandingPage> {
  int _currentIdx = 0;
  late Timer _timer;

  final List<Map<String, String>> _heroData = [
    {'image': 'assets/image/hotel.jpg', 'label': 'Hotel room doors'},
    {'image': 'assets/image/rental.jpg', 'label': 'Rental apartments'},
    {'image': 'assets/image/dorm.jpg', 'label': 'Dormitories'},
    {'image': 'assets/image/home.jpg', 'label': 'Home doors'},
    {'image': 'assets/image/basement.jpg', 'label': 'Basements'},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentIdx = (_currentIdx + 1) % _heroData.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Images
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: Container(
                key: ValueKey<int>(_currentIdx),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_heroData[_currentIdx]['image']!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.darken),
                  ),
                ),
              ),
            ),
          ),
          
          // Responsive Center Content
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SECURE ANY DOOR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 36 : 64, // Responsive Font Size
                          fontWeight: FontWeight.bold,
                          letterSpacing: isMobile ? 1 : 2,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          "Perfect for ${_heroData[_currentIdx]['label']}",
                          key: ValueKey<String>(_heroData[_currentIdx]['label']!),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 28, // Responsive Font Size
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          ),

          // Nav Bar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(),
          ),
        ],
      ),
    );
  }
}