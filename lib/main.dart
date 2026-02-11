import 'dart:async';
import 'package:flutter/material.dart';

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
      theme: ThemeData(brightness: Brightness.dark),
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
    {'image': 'assets/image/hotel.jpg', 'label': 'Hotel Room Doors'},
    {'image': 'assets/image/rental.jpg', 'label': 'Rental Apartments'},
    {'image': 'assets/image/dorm.jpg', 'label': 'Dormitories'},
    {'image': 'assets/image/home.jpg', 'label': 'Home Doors'},
    {'image': 'assets/image/basement.jpg', 'label': 'Basements'},
    {'image': 'assets/image/windows.jpg', 'label': 'Windows'},
  ];

  @override
  void initState() {
    super.initState();
    // Auto-fade every 3-4 seconds
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
          // 1. Background Image Slider
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

          // 2. Content Overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Same Product, All Locations",
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    "${_heroData[_currentIdx]['label']}",
                    key: ValueKey<String>(_heroData[_currentIdx]['label']!),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Frosted Glass Header with Hover Effects
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
              child: Row(
                children: [
                  const Text("STRAPIT",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Spacer(),
                  // Replaced _navItem with HoverNavBarItem
                  const HoverNavBarItem(title: "About Us"),
                  const HoverNavBarItem(title: "Product"),
                  const HoverNavBarItem(title: "Features"),
                  const HoverNavBarItem(title: "Pricing"),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                    child: const Text("Download / Buy",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Add this new class at the bottom of main.dart ---

class HoverNavBarItem extends StatefulWidget {
  final String title;

  const HoverNavBarItem({super.key, required this.title});

  @override
  State<HoverNavBarItem> createState() => _HoverNavBarItemState();
}

class _HoverNavBarItemState extends State<HoverNavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Background becomes slightly visible on hover
          color:
              _isHovered ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          // Optional: Add a subtle border on hover
          border: Border.all(
            color:
                _isHovered ? Colors.white.withOpacity(0.3) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            // Text color becomes brighter/blue on hover
            color: _isHovered ? const Color.fromARGB(255, 131, 176, 255) : Colors.white,
            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}