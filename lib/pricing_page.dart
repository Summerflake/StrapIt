import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'about_us.dart'; // Reusing the AnimatedBackground

class PricingPage extends StatefulWidget {
  const PricingPage({super.key});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  
  // Scroll Triggers
  bool _showHeader = false;
  bool _showCorridor = false;
  bool _showPriceCard = false;
  bool _showPartners = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initial Trigger
    Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _showHeader = true);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    double offset = _scrollController.offset;
    
    // Trigger thresholds
    if (offset > 100 && !_showCorridor) setState(() => _showCorridor = true);
    if (offset > 400 && !_showPriceCard) setState(() => _showPriceCard = true);
    if (offset > 800 && !_showPartners) setState(() => _showPartners = true);
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
          // Reuse standard background
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
                      const NavBar(),
                      
                      const SizedBox(height: 80),

                      // 1. HEADLINE & SUB-HEADLINE
                      _buildHeaderSection(isMobile),

                      const SizedBox(height: 100),

                      // 2. PRICE CORRIDOR (The "Low - Mid - High" Bar)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: _buildPriceCorridor(isMobile),
                      ),

                      const SizedBox(height: 100),

                      // 3. PRICING CARD (The $22.70 Spotlight)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: _buildPricingCard(isMobile),
                      ),

                      const SizedBox(height: 150),

                      // 4. PARTNERS
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: _buildPartnersSection(isMobile),
                      ),

                      const SizedBox(height: 150),
                      
                      // FOOTER (Simple Download CTA)
                      _buildFooter(),
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

  // --- 1. HEADLINE SECTION ---
  Widget _buildHeaderSection(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            opacity: _showHeader ? 1.0 : 0.0,
            child: const Text(
              "PRICING",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 30),
          AnimatedSlide(
            duration: const Duration(milliseconds: 1000),
            offset: _showHeader ? Offset.zero : const Offset(0, 0.5),
            curve: Curves.easeOutQuad,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1000),
              opacity: _showHeader ? 1.0 : 0.0,
              child: Text(
                "Secure, scalable, and affordable,\nfor anyone, anywhere.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: isMobile ? 28 : 42,
                  fontWeight: FontWeight.w300,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. PRICE CORRIDOR ANIMATION ---
  Widget _buildPriceCorridor(bool isMobile) {
    // Defines the scale of the bar: 0 to 500 USD
    // StrapIt = 22.70 (approx 5% position)
    // Competitors = 150 (30%), 500 (100%), 30 (6%), 10 (2%)
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("MARKET COMPARISON", style: TextStyle(color: Colors.black54, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 40),
        SizedBox(
          height: 180, // Increased height to accommodate labels
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // The Line (Draws left -> right)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutExpo,
                    width: _showCorridor ? width : 0,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.grey[300]!],
                        stops: const [0.1, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Labels (Low - Mid - High)
                  if (_showCorridor) ...[
                    const Positioned(left: 0, bottom: 40, child: Text("LOW", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent))),
                    Positioned(left: width / 2, bottom: 40, child: const Text("MID", style: TextStyle(color: Colors.grey))),
                    const Positioned(right: 0, bottom: 40, child: Text("HIGH", style: TextStyle(color: Colors.grey))),
                  ],

                  // COMPETITOR DOTS (Muted)
                  // Note: Positions slightly adjusted for visual clarity while keeping relative order
                  _buildPriceDot(width, 0.30, "\$150", false, 600),   // Smart Lock
                  _buildPriceDot(width, 0.95, "\$500+", false, 700),  // High end
                  _buildPriceDot(width, 0.02, "\$10", false, 800),    // Cheap latch
                  
                  // ADDED: $30 Price Point as per outline
                  _buildPriceDot(width, 0.08, "\$30", false, 900),    // Slightly offset from StrapIt

                  // STRAPIT DOT (Highlighted & Pulsing)
                  // 22.70 is approx 4.5% of 500. Placed between 10 and 30.
                  _buildPriceDot(width, 0.05, "\$22.70\nStrapIt", true, 1200),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceDot(double totalWidth, double pct, String label, bool isHero, int delay) {
    return Positioned(
      left: totalWidth * pct,
      // Adjust vertical position for hero to avoid overlap
      top: isHero ? 60 : 85, // Hero is higher up
      child: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: delay)),
        builder: (context, snapshot) {
          bool visible = _showCorridor && snapshot.connectionState == ConnectionState.done;
          
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: visible ? 1.0 : 0.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The Dot on the line (which is vertically centered in Stack approx at top ~90)
                // We use transform to visually place the dot on the line while keeping text layout
                Transform.translate(
                  offset: Offset(0, isHero ? 20 : -5), // Fine tune dot position relative to line
                  child: isHero
                    ? const PulsingDot()
                    : Container(
                        width: 12, height: 12,
                        decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isHero ? Colors.blueAccent : Colors.grey[400],
                    fontWeight: isHero ? FontWeight.bold : FontWeight.normal,
                    fontSize: isHero ? 16 : 12,
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }

  // --- 3. PRICING CARD ---
  Widget _buildPricingCard(bool isMobile) {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),
        opacity: _showPriceCard ? 1.0 : 0.0,
        curve: Curves.easeOut,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 1000),
          offset: _showPriceCard ? Offset.zero : const Offset(0, 0.1),
          // We wrap the content in a container to hold shadows first
          // Shadows must be outside ClipRRect to be visible
          child: Container(
            width: isMobile ? double.infinity : 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.blueAccent.withOpacity(0.1), blurRadius: 40, offset: const Offset(0, 15)),
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            // The ClipRRect clips the blur effect to the border radius
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0), // Strong frosted blur
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.65), // White tint, but semi-transparent
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.blueAccent.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      // Header
                      const Text("STRAPIT ONE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
                      const SizedBox(height: 10),
                      const Text("USD \$22.70", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 40),
                      
                      // Features
                      _buildFeatureRow("One-time purchase"),
                      _buildFeatureRow("No installation cost"),
                      _buildFeatureRow("No drilling required"),
                      _buildFeatureRow("App-controlled alarm"),
                      
                      const SizedBox(height: 50),
                      
                      // Pulsing Button
                      const PulsingButton(text: "Buy StrapIt"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }

  // --- 4. PARTNERS SECTION ---
  Widget _buildPartnersSection(bool isMobile) {
    final List<String> partners = [
      "Federal Law Enforcement", "Trip.com", "Tripadvisor", "Agoda",
      "Bryant Park Hotel", "Bar Harbor Inn", "Smart Nation", "HTX"
    ];

    return Column(
      children: [
        AnimatedOpacity(
          opacity: _showPartners ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          child: const Text("OUR PARTNERS", style: TextStyle(color: Colors.black45, letterSpacing: 2, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 30,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: partners.asMap().entries.map((entry) {
            return _buildPartnerLogo(entry.value, entry.key);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPartnerLogo(String name, int index) {
    // Simulating the "Greyscale by default, Color on Hover" effect
    // Since we don't have images, we use text with color transition
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 200 * index)), // Staggered entrance
      builder: (context, snapshot) {
        bool visible = _showPartners && snapshot.connectionState == ConnectionState.done;
        
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: visible ? 1.0 : 0.0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 500),
            offset: visible ? Offset.zero : const Offset(0, 0.5),
            child: InteractivePartnerText(name: name),
          ),
        );
      }
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Icon(Icons.download, size: 40, color: Colors.blueAccent),
          const SizedBox(height: 20),
          const Text("Secure your space today.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {}, 
            child: const Text("Download App >", style: TextStyle(fontSize: 16, color: Colors.blueAccent))
          )
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HELPER WIDGETS
// ---------------------------------------------------------------------------

class PulsingDot extends StatefulWidget {
  const PulsingDot({super.key});

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _scale = Tween(begin: 1.0, end: 2.5).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = Tween(begin: 0.6, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fade.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Container(
                  width: 16, height: 16,
                  decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                ),
              ),
            );
          },
        ),
        Container(
          width: 16, height: 16,
          decoration: BoxDecoration(
            color: Colors.blueAccent, 
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2)
          ),
        ),
      ],
    );
  }
}

class PulsingButton extends StatefulWidget {
  final String text;
  const PulsingButton({super.key, required this.text});

  @override
  State<PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<PulsingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    // "Gently pulses every 5 seconds" -> Wait 4s, Pulse 1s
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _startPulseLoop();
    
    _scale = Tween(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _startPulseLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (mounted && !_isHovered) {
        await _controller.forward();
        await _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _isHovered ? 1.0 : _scale.value, // Don't pulse if hovered
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _isHovered 
                    ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)]
                    : [],
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    widget.text,
                    style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class InteractivePartnerText extends StatefulWidget {
  final String name;
  const InteractivePartnerText({super.key, required this.name});

  @override
  State<InteractivePartnerText> createState() => _InteractivePartnerTextState();
}

class _InteractivePartnerTextState extends State<InteractivePartnerText> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0, _hover ? -5 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _hover ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hover ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : [],
          border: Border.all(color: _hover ? Colors.blueAccent.withOpacity(0.1) : Colors.transparent),
        ),
        child: Text(
          widget.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _hover ? Colors.blueAccent : Colors.grey[400], // Grayscale to Color
          ),
        ),
      ),
    );
  }
}