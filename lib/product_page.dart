import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'about_us.dart'; // Import for AnimatedBackground reuse

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showContent = false;
  bool _showDiagram = false;
  late AnimationController _drawController;

  // Components list from Page 4 of Outline
  final List<String> _components = [
    "Adjustable high-strength strap",
    "Non-intrusive clamp mechanism",
    "Force sensor",
    "Alarm module",
    "Small piezo buzzer",
    "Controller",
    "Push buttons",
    "Battery compartment"
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Animation controller for the diagram drawing
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Slower duration for clear sequencing
    );

    Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  void _onScroll() {
    if (_scrollController.hasClients && _scrollController.offset > 100 && !_showDiagram) {
      setState(() {
        _showDiagram = true;
        _drawController.forward();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _drawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()), 
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isMobile = constraints.maxWidth < 900;
                  return Column(
                    children: [
                      const NavBar(),

                      // --- SECTION 1: PRODUCT DESCRIPTION ---
                      const SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 1000),
                          opacity: _showContent ? 1.0 : 0.0,
                          child: Column(
                            children: [
                              const Text(
                                "THE PRODUCT",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                constraints: const BoxConstraints(maxWidth: 800),
                                child: Text(
                                  "StrapIt is a portable strap-based smart lock that reinforces doors and windows without drilling, replacing existing locks, or causing damage.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 18 : 24,
                                    height: 1.5,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 120),

                      // --- SECTION 2: TECHNICAL SPECIFICATIONS ---
                      _buildSectionHeader("Technical Specifications"),
                      const SizedBox(height: 60),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 1000),
                          opacity: _showDiagram ? 1.0 : 0.0,
                          curve: Curves.easeOut,
                          child: Column(
                            children: [
                              // RESPONSIVE EXPLODED VIEW
                              isMobile 
                              ? Column(
                                  children: [
                                    _buildExplodedImage(isMobile),
                                    const SizedBox(height: 40),
                                    _buildComponentList(_components, CrossAxisAlignment.start),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center, 
                                  children: [
                                    Expanded(child: _buildComponentList(_components.sublist(0, 4), CrossAxisAlignment.end)),
                                    _buildExplodedImage(isMobile),
                                    Expanded(child: _buildComponentList(_components.sublist(4), CrossAxisAlignment.start)),
                                  ],
                                ),

                              const SizedBox(height: 100),

                              // --- NEW ANIMATED DIAGRAM ---
                              // Wrapped in FittedBox to scale on mobile
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: _buildAnimatedDiagram(),
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

  Widget _buildExplodedImage(bool isMobile) {
    return Container(
      width: isMobile ? 300 : 400,
      height: isMobile ? 300 : 500,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          "assets/image/explode.jpg", 
          fit: BoxFit.contain, 
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.white24)),
        ),
      ),
    );
  }

  // --- ANIMATED DIAGRAM BUILDER ---
  Widget _buildAnimatedDiagram() {
    return AnimatedBuilder(
      animation: _drawController,
      builder: (context, child) {
        return SizedBox(
          height: 600, // Adjusted height to fit all elements vertically
          width: 500,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. OVAL (Top Right) - Drawn line-by-line
              Positioned(
                top: 50,
                left: 150, 
                child: CustomPaint(
                  size: const Size(250, 100),
                  painter: OvalDrawingPainter(progress: _drawController.value, start: 0.0, end: 0.3),
                ),
              ),

              // 2. GREEN ROUNDED SQUARE (Top Left)
              Positioned(
                top: 40,
                left: 50,
                child: _buildAnimatedElement(
                  start: 0.3, end: 0.5,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C853), // Vivid Green
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              // 3. RED ROUNDED RECTANGLE (Bottom Left, below Green)
              Positioned(
                top: 140, // Directly below the green square (40 + 110 - overlap slightly or just touch)
                left: 30, // Slightly wider/offset left as per screenshot
                child: _buildAnimatedElement(
                  start: 0.5, end: 0.7,
                  child: Container(
                    width: 140,
                    height: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB71C1C), // Deep Red
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              // 4. CLAMP TEXT (Below Red Rectangle)
              Positioned(
                top: 370, 
                left: 60, // Centered relative to red rectangle
                child: _buildAnimatedElement(
                  start: 0.7, end: 0.8,
                  child: const Text(
                    "Clamp",
                    style: TextStyle(
                      color: Colors.white, // White text to be visible on dark bg
                      fontSize: 28, 
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat', // Updated Font
                    ),
                  ),
                ),
              ),

              // 5. CLAMP IMAGE (Below Text)
              Positioned(
                top: 410,
                left: 50,
                child: _buildAnimatedElement(
                  start: 0.8, end: 1.0,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/image/clamp.jpg",
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(color: Colors.grey, child: const Icon(Icons.image)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper to control opacity/scale animation sequence
  Widget _buildAnimatedElement({required double start, required double end, required Widget child}) {
    final double progress = (_drawController.value - start) / (end - start);
    final double clampedProgress = progress.clamp(0.0, 1.0);
    
    return Opacity(
      opacity: clampedProgress,
      child: Transform.scale(
        scale: 0.8 + (0.2 * clampedProgress), // Subtle pop-in effect
        child: child,
      ),
    );
  }

  Widget _buildComponentList(List<String> items, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (align == CrossAxisAlignment.end) ...[
                 Text(item, style: const TextStyle(color: Colors.cyanAccent, fontSize: 16)),
                 const SizedBox(width: 15),
                 const Icon(Icons.circle, size: 8, color: Colors.blueAccent),
              ] else ...[
                 const Icon(Icons.circle, size: 8, color: Colors.blueAccent),
                 const SizedBox(width: 15),
                 Text(item, style: const TextStyle(color: Colors.cyanAccent, fontSize: 16)),
              ]
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 16,
        letterSpacing: 2,
      ),
    );
  }
}

// Custom Painter specifically for the Oval line drawing
class OvalDrawingPainter extends CustomPainter {
  final double progress;
  final double start;
  final double end;

  OvalDrawingPainter({required this.progress, required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    // Check if we should start painting
    if (progress < start) return;

    final Paint paint = Paint()
      ..color = Colors.black // Per screenshot: Black stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0; // Thick stroke per screenshot

    // Define the Oval path
    final Path path = Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));

    // Calculate how much of the path to draw
    final double localProgress = ((progress - start) / (end - start)).clamp(0.0, 1.0);
    
    final PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      final double extractEnd = pathMetric.length * localProgress;
      final Path extractPath = pathMetric.extractPath(0.0, extractEnd);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant OvalDrawingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}