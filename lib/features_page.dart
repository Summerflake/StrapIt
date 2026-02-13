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

  // Notification State
  bool _showNotificationOverlay = false;
  bool _hasShownNotification = false; // Ensures it only pops up once per session

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
    
    // Feature 2 (Intrusion Alarm) Threshold
    if (offset > 400) {
      if (!_showFeature2) setState(() => _showFeature2 = true);
      
      // Trigger Notification Popup (Once)
      if (!_hasShownNotification) {
        setState(() {
          _showNotificationOverlay = true;
          _hasShownNotification = true;
        });
        
        // Auto-hide notification after 5 seconds
        Timer(const Duration(seconds: 5), () {
          if (mounted) setState(() => _showNotificationOverlay = false);
        });
      }
    }

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 900;
          double horizontalPadding = isMobile ? 20 : 60;

          return Stack(
            children: [
              // Reuse background from About Us
              const Positioned.fill(child: AnimatedBackground()),
              
              // MAIN SCROLLABLE CONTENT
              Positioned.fill(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // NavBar
                      const NavBar(),

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
                        // REMOVED: visual argument so text shifts left
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
                  ),
                ),
              ),

              // ---------------------------------------------------------
              // GLOBAL NOTIFICATION OVERLAY
              // ---------------------------------------------------------
              GlobalNotificationOverlay(
                isVisible: _showNotificationOverlay,
                isMobile: isMobile,
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildFeatureSection({
    required bool isMobile,
    required bool trigger,
    required bool isImageRight,
    required String title,
    required List<String> descriptionPoints,
    Widget? visual, // CHANGED: Made optional
    required String imagePath,
  }) {
    // We scale the visual using FittedBox to ensure it fits on small screens
    Widget? scalableVisual = visual != null ? FittedBox(fit: BoxFit.scaleDown, child: visual) : null;

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
                   if (scalableVisual != null) ...[
                     scalableVisual,
                     const SizedBox(height: 40),
                   ],
                   _buildTextContent(title, descriptionPoints, imagePath),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IF VISUAL LEFT
                  if (!isImageRight && scalableVisual != null) ...[
                    Expanded(child: Center(child: scalableVisual)),
                    const SizedBox(width: 80),
                  ],

                  // TEXT CONTENT
                  Expanded(
                    child: _buildTextContent(title, descriptionPoints, imagePath),
                  ),

                  // IF VISUAL RIGHT
                  if (isImageRight && scalableVisual != null) ...[
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
        const SizedBox(height: 30),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            imagePath,
            height: 250, 
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
                child: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 40),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 2. Global Notification Overlay (Popup)
class GlobalNotificationOverlay extends StatelessWidget {
  final bool isVisible;
  final bool isMobile;

  const GlobalNotificationOverlay({
    required this.isVisible,
    required this.isMobile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      // Mobile: Top (-200 hidden, 20 shown)
      // Desktop: Bottom Right
      top: isMobile 
          ? (isVisible ? 20 : -200) 
          : null,
      bottom: isMobile ? null : 40,
      left: isMobile ? 20 : null,
      right: isMobile 
          ? 20 
          : (isVisible ? 40 : -400), // Desktop slide in from right
      
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isVisible ? 1.0 : 0.0,
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            width: isMobile ? null : 350, // Fixed width on desktop
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_rounded, color: Colors.red, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("STRAPIT ALERT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                          Text("now", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Intrusion Detected",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Force sensors have detected an unauthorized entry attempt.",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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