import 'dart:async';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'about_us.dart'; // Reusing AnimatedBackground

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // Scroll Triggers
  bool _showPartners = false;
  bool _showBuy = false;
  bool _showDownload = false;
  bool _showFooter = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Trigger first section immediately
    Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _showPartners = true);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    double offset = _scrollController.offset;
    
    if (offset > 200 && !_showBuy) setState(() => _showBuy = true);
    if (offset > 500 && !_showDownload) setState(() => _showDownload = true);
    if (offset > 700 && !_showFooter) setState(() => _showFooter = true);
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
          // Background
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
                      const NavBar(isLightMode: true),
                      const SizedBox(height: 80),

                      // 1. PARTNERS SECTION
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Column(
                          children: [
                            _buildSectionHeader("Trusted By"),
                            const SizedBox(height: 50),
                            _buildPartnersGrid(isMobile),
                          ],
                        ),
                      ),

                      const SizedBox(height: 150),

                      // 2. BUY SECTION
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 800),
                          opacity: _showBuy ? 1.0 : 0.0,
                          child: Column(
                            children: [
                              const Text(
                                "Get StrapIt Today",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Secure your world for just \$22.70",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 60),
                              // Custom Pulsing Button
                              const PulsingBuyButton(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 150),

                      // 3. DOWNLOAD APP SECTION
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 80, horizontal: horizontalPadding),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border(top: BorderSide(color: Colors.grey[200]!)),
                        ),
                        child: Column(
                          children: [
                            _buildSectionHeader("Download The App"),
                            const SizedBox(height: 60),
                            
                            // Sliding Buttons
                            _buildDownloadButtons(isMobile),
                          ],
                        ),
                      ),

                      // 4. FOOTER / SOCIALS
                      Container(
                        width: double.infinity,
                        color: const Color(0xFF1A1A1A),
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 1000),
                          opacity: _showFooter ? 1.0 : 0.0,
                          child: Column(
                            children: [
                              const Text("FOLLOW US", style: TextStyle(color: Colors.white54, letterSpacing: 2)),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialIcon(Icons.camera_alt_outlined), // Instagram placeholder
                                  const SizedBox(width: 30),
                                  _buildSocialIcon(Icons.music_note), // TikTok placeholder
                                  const SizedBox(width: 30),
                                  _buildSocialIcon(Icons.play_arrow_outlined), // YouTube placeholder
                                ],
                              ),
                              const SizedBox(height: 40),
                              const Text(
                                "© 2026 StrapIt. All rights reserved.",
                                style: TextStyle(color: Colors.white24, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.blueAccent,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
      ),
    );
  }

  // --- PARTNERS GRID ---
  Widget _buildPartnersGrid(bool isMobile) {
    final List<Map<String, dynamic>> partners = [
      {'name': 'Federal Law\nEnforcement', 'icon': Icons.security},
      {'name': 'Trip.com', 'icon': Icons.flight_takeoff},
      {'name': 'Tripadvisor', 'icon': Icons.remove_red_eye},
      {'name': 'Agoda', 'icon': Icons.hotel},
      {'name': 'Bryant Park\nHotel', 'icon': Icons.apartment},
      {'name': 'Bar Harbor\nInn', 'icon': Icons.holiday_village},
      {'name': 'Smart Nation\nInitiative', 'icon': Icons.lightbulb_outline},
      {'name': 'HTX\nScience & Tech', 'icon': Icons.science},
    ];

    return Wrap(
      spacing: 40,
      runSpacing: 40,
      alignment: WrapAlignment.center,
      children: List.generate(partners.length, (index) {
        return FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 100 * index)), // Staggered delay
          builder: (context, snapshot) {
            bool visible = _showPartners && snapshot.connectionState == ConnectionState.done;
            
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: visible ? 1.0 : 0.0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 600),
                offset: visible ? Offset.zero : const Offset(0, 0.2),
                child: PartnerLogoItem(
                  name: partners[index]['name'],
                  icon: partners[index]['icon'],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // --- SLIDING DOWNLOAD BUTTONS ---
  Widget _buildDownloadButtons(bool isMobile) {
    return isMobile 
      ? Column(
          children: [
            _buildSlideBtn(true, "App Store", Icons.apple),
            const SizedBox(height: 20),
            _buildSlideBtn(false, "Google Play", Icons.android),
          ],
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSlideBtn(true, "App Store", Icons.apple),
            const SizedBox(width: 40),
            _buildSlideBtn(false, "Google Play", Icons.android),
          ],
        );
  }

  Widget _buildSlideBtn(bool fromLeft, String label, IconData icon) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      // Slide in from left (-1.0) or right (1.0)
      offset: _showDownload ? Offset.zero : Offset(fromLeft ? -1.5 : 1.5, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 800),
        opacity: _showDownload ? 1.0 : 0.0,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(icon, size: 28),
          label: Text(label, style: const TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white, size: 30),
      hoverColor: Colors.blueAccent.withOpacity(0.2),
    );
  }
}

// ---------------------------------------------------------------------------
// HELPER WIDGETS
// ---------------------------------------------------------------------------

// 1. PARTNER LOGO ITEM (Greyscale to Color + Lift)
class PartnerLogoItem extends StatefulWidget {
  final String name;
  final IconData icon;

  const PartnerLogoItem({super.key, required this.name, required this.icon});

  @override
  State<PartnerLogoItem> createState() => _PartnerLogoItemState();
}

class _PartnerLogoItemState extends State<PartnerLogoItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        // Upward lift on hover
        transform: Matrix4.translationValues(0, _isHovered ? -10 : 0, 0),
        width: 140,
        height: 140,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
          border: Border.all(
            color: _isHovered ? Colors.blueAccent.withOpacity(0.3) : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simulating Greyscale -> Color using Icon color
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                widget.icon,
                size: 40,
                // Grey by default, Blue on hover
                color: _isHovered ? Colors.blueAccent : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                // Grey text -> Black text
                color: _isHovered ? Colors.black87 : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. PULSING BUY BUTTON
class PulsingBuyButton extends StatefulWidget {
  const PulsingBuyButton({super.key});

  @override
  State<PulsingBuyButton> createState() => _PulsingBuyButtonState();
}

class _PulsingBuyButtonState extends State<PulsingBuyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    // Pulse every 5 seconds (Wait 4s, Pulse 1s)
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _startPulseLoop();
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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double pulseScale = 1.0 + (_controller.value * 0.05); // Subtle pulse
          double hoverScale = _isHovered ? 1.1 : 1.0;
          double totalScale = _isHovered ? hoverScale : pulseScale;

          return Transform.scale(
            scale: totalScale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  // Glow Effect
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(_isHovered ? 0.6 : 0.3),
                    blurRadius: _isHovered ? 30 : 15,
                    spreadRadius: _isHovered ? 5 : 0,
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  elevation: 0, // Handled by Container shadow
                ),
                child: const Text(
                  "BUY STRAPIT",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}