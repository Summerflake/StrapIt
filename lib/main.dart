import 'dart:async';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'about_us.dart'; // Imported to use AnimatedBackground
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
        textTheme: GoogleFonts.montserratTextTheme(),
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
  
  // Scroll & Animation State
  final ScrollController _scrollController = ScrollController();
  bool _showVideo = false;

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
    // Background Image Rotator
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentIdx = (_currentIdx + 1) % _heroData.length;
        });
      }
    });

    // Scroll Listener for Fade-In Effect
    _scrollController.addListener(() {
      if (!_showVideo && _scrollController.offset > 150) {
        setState(() {
          _showVideo = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background for the page
      body: Stack(
        children: [
          // SCROLLABLE CONTENT
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // -----------------------------------------------------------
                // 1. HERO SECTION (Full Viewport Height)
                // -----------------------------------------------------------
                SizedBox(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: Stack(
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
                                // Added FilterQuality.high for sharpness
                                filterQuality: FilterQuality.high,
                                // Reduced opacity slightly (0.4 -> 0.3) to make image clearer
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.3), BlendMode.darken),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Hero Text Content
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  bool isMobile = constraints.maxWidth < 600;
                                  return Text(
                                    "SECURE ANY DOOR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isMobile ? 36 : 64,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: isMobile ? 1 : 2,
                                      color: Colors.white,
                                      height: 1.1,
                                    ),
                                  );
                                }
                              ),
                              const SizedBox(height: 20),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: Text(
                                  "Perfect for ${_heroData[_currentIdx]['label']}",
                                  key: ValueKey<String>(_heroData[_currentIdx]['label']!),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Scroll Down Indicator
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 10),
                            duration: const Duration(seconds: 1),
                            builder: (context, val, child) {
                              return Transform.translate(
                                offset: Offset(0, val),
                                child: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 40),
                              );
                            },
                            onEnd: () {}, 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // -----------------------------------------------------------
                // 2. VIDEO PROMOTION SECTION (Below the fold)
                // -----------------------------------------------------------
                Stack(
                  children: [
                    // BACKGROUND EFFECT: Animated Dots/Particles + White BG
                    // FIX: Wrapped in ClipRect to stop blur from bleeding up to the Hero section
                    const Positioned.fill(
                      child: ClipRect(
                        child: AnimatedBackground(),
                      ),
                    ),

                    // FOREGROUND CONTENT
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                      child: Column(
                        children: [
                          // Section Header
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 1000),
                            opacity: _showVideo ? 1.0 : 0.0,
                            child: const Text(
                              "SEE IT IN ACTION",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),

                          // Video Placeholder with Fade In
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeOut,
                            opacity: _showVideo ? 1.0 : 0.0,
                            child: AnimatedSlide(
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.easeOutQuad,
                              offset: _showVideo ? Offset.zero : const Offset(0, 0.1),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  bool isMobile = constraints.maxWidth < 600;
                                  return Container(
                                    width: isMobile ? double.infinity : 800,
                                    height: isMobile ? 250 : 450,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 30,
                                          offset: const Offset(0, 15),
                                        )
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Thumbnail Placeholder
                                        Opacity(
                                          opacity: 0.3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              image: const DecorationImage(
                                                image: AssetImage('assets/image/hotel.jpg'), // Placeholder
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Play Button
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(0.2),
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
                                        ),
                                        Positioned(
                                          bottom: 30,
                                          child: Text(
                                            "Watch Promotion Video",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.9),
                                              letterSpacing: 1.5,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // -----------------------------------------------------------
          // 3. NAVIGATION BAR (Fixed at Top)
          // -----------------------------------------------------------
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