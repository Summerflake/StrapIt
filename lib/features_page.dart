import 'dart:async';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'about_us.dart'; // Reusing AnimatedBackground

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({super.key});

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  
  // Triggers for scroll animations
  bool _showFeature1 = false;
  bool _showFeature2 = false;
  bool _showFeature3 = false;
  bool _showWhy = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Trigger first section immediately after build
    Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _showFeature1 = true);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    double offset = _scrollController.offset;
    
    // Adjust thresholds based on your layout needs
    if (offset > 400 && !_showFeature2) setState(() => _showFeature2 = true);
    if (offset > 900 && !_showFeature3) setState(() => _showFeature3 = true);
    if (offset > 1300 && !_showWhy) setState(() => _showWhy = true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Reuse background from About Us
          const Positioned.fill(child: AnimatedBackground()),
          
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isMobile = constraints.maxWidth < 900;
                  double horizontalPadding = isMobile ? 20 : 60;

                  return Column(
                    children: [
                      // NavBar
                      const NavBar(isLightMode: true),

                      const SizedBox(height: 60),
                      
                      // PAGE HEADER
                      const Text(
                        "FEATURES",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 80),

                      // ---------------------------------------------------------
                      // FEATURE 1: PORTABLE & NON-DESTRUCTIVE
                      // ---------------------------------------------------------
                      _buildFeatureSection(
                        isMobile: isMobile,
                        trigger: _showFeature1,
                        isImageRight: true,
                        title: "1. Portable & Non-Destructive",
                        descriptionPoints: [
                          "No drilling or permanent installation",
                          "No need to replace existing locks",
                          "Leaves no marks on doors or frames"
                        ],
                        // Custom Animation: Strap Tightening / Clamp
                        visual: const StrapClampAnimation(),
                        // ADDED: Specific image for Feature 1
                        imagePath: 'assets/image/human.jpg', 
                      ),

                      // ---------------------------------------------------------
                      // FEATURE 2: INTRUSION ALARM
                      // ---------------------------------------------------------
                      _buildFeatureSection(
                        isMobile: isMobile,
                        trigger: _showFeature2,
                        isImageRight: false, // Visual on Left
                        title: "2. Intrusion Alarm",
                        descriptionPoints: [
                          "Detects forced entry through force sensors",
                          "Alarm rings continuously until disabled via app",
                          "Forces intruders to leave immediately"
                        ],
                        // Custom Animation: Notification Pop-up
                        visual: const NotificationSlideAnimation(),
                        // ADDED: Specific image for Feature 2
                        imagePath: 'assets/image/crime.jpg',
                      ),

                      // ---------------------------------------------------------
                      // FEATURE 3: APP-CONTROLLED SMART SECURITY
                      // ---------------------------------------------------------
                      _buildFeatureSection(
                        isMobile: isMobile,
                        trigger: _showFeature3,
                        isImageRight: true,
                        title: "3. App-Controlled Smart Security",
                        descriptionPoints: [
                          "Connects to mobile app",
                          "Remote alarm control",
                          "Smart protection without smart-lock replacement"
                        ],
                        // Custom Animation: App Toggle Button
                        visual: const AppToggleAnimation(),
                        // ADDED: Specific image for Feature 3
                        imagePath: 'assets/image/dontknow.jpg',
                      ),

                      const SizedBox(height: 100),

                      // ---------------------------------------------------------
                      // WHY STRAPIT SUMMARY
                      // ---------------------------------------------------------
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 1000),
                          opacity: _showWhy ? 1.0 : 0.0,
                          child: Column(
                            children: [
                              const Text(
                                "WHY STRAPIT",
                                style: TextStyle(color: Colors.blueAccent, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 40),
                              Container(
                                padding: EdgeInsets.all(isMobile ? 20 : 40),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: const Text(
                                  "StrapIt removes unnecessary complexity found in conventional smart locks by focusing on what matters most: ease of use, affordability, and effective protection. By eliminating costly motors, heavy metal housings, and complex software systems, StrapIt significantly reduces cost and technical barriers while maintaining reliable security through mechanical reinforcement and alert-based intrusion detection.\n\n It's portable, non-intrusive design allows users to install and remove the device instantly without modifying existing locks, making it ideal for renters, travellers, and short-term residents. StrapIt delivers a practical, scalable security solution that prioritises simplicity, accessibility, and real-world usability.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    height: 1.6,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 150),
                    ],
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection({
    required bool isMobile,
    required bool trigger,
    required bool isImageRight,
    required String title,
    required List<String> descriptionPoints,
    required Widget visual,
    required String imagePath, // ADDED: New parameter for the JPG
  }) {
    // We scale the visual using FittedBox to ensure it fits on small screens
    Widget scalableVisual = FittedBox(fit: BoxFit.scaleDown, child: visual);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 80),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),
        opacity: trigger ? 1.0 : 0.0,
        curve: Curves.easeOut,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 1000),
          offset: trigger ? Offset.zero : const Offset(0, 0.1),
          child: isMobile 
            ? Column(
                children: [
                   scalableVisual,
                   const SizedBox(height: 40),
                   // Pass imagePath to text content
                   _buildTextContent(title, descriptionPoints, imagePath),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Align to top
                children: [
                  // IF VISUAL LEFT
                  if (!isImageRight) ...[
                    Expanded(child: Center(child: scalableVisual)),
                    const SizedBox(width: 80),
                  ],

                  // TEXT CONTENT (Now includes the JPG at bottom)
                  Expanded(
                    child: _buildTextContent(title, descriptionPoints, imagePath),
                  ),

                  // IF VISUAL RIGHT
                  if (isImageRight) ...[
                    const SizedBox(width: 80),
                    Expanded(child: Center(child: scalableVisual)),
                  ],
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildTextContent(String title, List<String> descriptionPoints, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        ...descriptionPoints.map((point) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.circle, size: 8, color: Colors.blueAccent),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  point,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )),
        
        // ------------------------------------------------------
        // ADDED: The Image below the text bullets
        // ------------------------------------------------------
        const SizedBox(height: 30),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            imagePath,
            height: 250, // Fixed height for consistency
            width: double.infinity,
            fit: BoxFit.cover, 
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 250,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const Text("Image not found", style: TextStyle(color: Colors.grey)),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// CUSTOM ANIMATION WIDGETS
// ============================================================================

// 1. Strap/Clamp Animation
class StrapClampAnimation extends StatefulWidget {
  const StrapClampAnimation({super.key});

  @override
  State<StrapClampAnimation> createState() => _StrapClampAnimationState();
}

class _StrapClampAnimationState extends State<StrapClampAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _strapWidth;
  late Animation<double> _clampSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    
    _strapWidth = Tween<double>(begin: 300, end: 220).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeInOut)),
    );

    _clampSlide = Tween<double>(begin: 0, end: 40).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.7, curve: Curves.elasticOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // CHANGED: Light grey handle for visibility on white
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
          
          // The Strap
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: _strapWidth.value,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Center(
                  child: Text("STRAP TIGHTENING...", style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              );
            },
          ),

          // Left Clamp
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: 30 + _clampSlide.value,
                // CHANGED: Dark icon for visibility
                child: const Icon(Icons.arrow_forward_ios, color: Colors.black87, size: 40),
              );
            },
          ),
          
           // Right Clamp
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                right: 30 + _clampSlide.value,
                // CHANGED: Dark icon for visibility
                child: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 40),
              );
            },
          ),
        ],
      ),
    );
  }
}


// 2. Notification Slide Animation
class NotificationSlideAnimation extends StatefulWidget {
  const NotificationSlideAnimation({super.key});

  @override
  State<NotificationSlideAnimation> createState() => _NotificationSlideAnimationState();
}

class _NotificationSlideAnimationState extends State<NotificationSlideAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -2.0),
      end: const Offset(0, 0.2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      reverseCurve: const Interval(0.7, 1.0, curve: Curves.easeIn),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 450,
      decoration: BoxDecoration(
        // CHANGED: White phone body
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey[300]!, width: 4),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 40)],
      ),
      child: Stack(
        children: [
          // Screen Content
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // CHANGED: Lighter screen background
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(child: Icon(Icons.lock, size: 60, color: Colors.black12)),
            ),
          ),
          
          // Notification Bubble
          SlideTransition(
            position: _offsetAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("ALERT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red)),
                        Text("Forced entry detected!", style: TextStyle(fontSize: 12, color: Colors.black)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


// 3. App Toggle Animation
class AppToggleAnimation extends StatefulWidget {
  const AppToggleAnimation({super.key});

  @override
  State<AppToggleAnimation> createState() => _AppToggleAnimationState();
}

class _AppToggleAnimationState extends State<AppToggleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _colorAnim = ColorTween(begin: Colors.greenAccent, end: Colors.green).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("StrapIt App", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _colorAnim.value,
                  boxShadow: [
                    BoxShadow(color: _colorAnim.value!.withOpacity(0.5), blurRadius: 20 * _scaleAnim.value)
                  ],
                ),
                child: Transform.scale(
                  scale: _scaleAnim.value,
                  child: const Icon(Icons.shield_outlined, size: 50, color: Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          const Text("Status: SECURE", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}