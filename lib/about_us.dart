import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'nav_bar.dart';
import 'background.dart';
import 'home_page.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _statsKey = GlobalKey(); // Key to locate stats section
  
  bool _statsVisible = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_statsVisible) return;

    // Check if the stats section is visible on screen
    if (_statsKey.currentContext != null) {
      final RenderBox box = _statsKey.currentContext!.findRenderObject() as RenderBox;
      final Offset position = box.localToGlobal(Offset.zero);
      final double screenHeight = MediaQuery.of(context).size.height;

      // Trigger when the top of the stats section enters the bottom 25% of the viewport
      if (position.dy < screenHeight * 0.90) {
        if (mounted) {
          setState(() => _statsVisible = true);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 900;
    double horizontalPadding = isMobile ? 20 : 60;
    
    double spacing = 20;
    int columns = isMobile ? 1 : 3;
    double totalSpacing = spacing * (columns - 1);
    double availableWidth = screenWidth - (horizontalPadding * 2);
    double cardWidth = (availableWidth - totalSpacing) / columns;
    if (cardWidth < 100) cardWidth = 100;

    // Header Style Reference
    TextStyle headerStyle = const TextStyle(
        color: Colors.blueAccent,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: GlobalBackground()),

          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const NavBar(isHome: false),

                const SizedBox(height: 60),

                // 1. WHO WE ARE (MERGED WITH VISION & MISSION)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      Text("WHO WE ARE", style: headerStyle),
                      const SizedBox(height: 50),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Column(
                          children: [
                            // VISION SUB-SECTION
                            _buildInfoSection(
                              title: "Our Vision",
                              description: "A future where security is not fixed to buildings, but moves with people. To secure every space, everywhere. To reimagine security for a mobile world.",
                            ),
                            
                            const SizedBox(height: 60),

                            // MISSION SUB-SECTION
                            _buildInfoSection(
                              title: "Our Mission",
                              description: "To make personal security portable, affordable, and effortless, wherever people stay."
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 2. TEAM INTRODUCTION (Previously #3)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      Text("TEAM INTRODUCTION", style: headerStyle),
                      const SizedBox(height: 40),
                      Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        alignment: WrapAlignment.center,
                        children: [
                          TeamMemberCard(width: cardWidth, name: "XinYu", role: "Project Manager & DS Lead", description: "Owns delivery governance and Machine-Learning training."),
                          TeamMemberCard(width: cardWidth, name: "Jiachuan", role: "R&D Lead", description: "Curates regional food datasets and aligns features with nutrition evidence."),
                          TeamMemberCard(width: cardWidth, name: "ChengAo", role: "Application Development", description: "In charge of UI/UX and API integration."),
                          TeamMemberCard(width: cardWidth, name: "XiaoYu", role: "Community Manager", description: "Runs user analytics, A/B testing, and UAT prior to CI/CD releases."),
                          TeamMemberCard(width: cardWidth, name: "BangYan", role: "Marketing", description: "Leads go-to-market strategy and monetization."),
                          TeamMemberCard(width: cardWidth, name: "You!", role: "Future Partner", description: "We look forward for you to join us!"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 3. THE PROBLEM (Previously #4)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: 80, horizontal: horizontalPadding),
                  color: Colors.white.withOpacity(0.5),
                  child: Column(
                    children: [
                      Text("THE PROBLEM WE ADDRESS", style: headerStyle),
                      const SizedBox(height: 30),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: const Text(
                          "Urban living, frequent travel, and shared accommodations have increased exposure to unauthorized entry, while existing solutions force users to choose between high cost, permanent installation, or limited protection.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, height: 1.6, fontWeight: FontWeight.w400, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 50),
                      
                      const Text("Burglary Statistics (2024-2025)",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 40),

                      // STATS ROW WITH ROLLING NUMBERS
                      Container(
                        key: _statsKey,
                        child: Wrap(
                          spacing: 60,
                          runSpacing: 40,
                          alignment: WrapAlignment.center,
                          children: [
                            RollingStatItem(
                              isVisible: _statsVisible,
                              targetString: "60,000+", 
                              label: "Offenses Reported\nin the US"
                            ),
                            RollingStatItem(
                              isVisible: _statsVisible,
                              targetString: "< 20%", 
                              label: "Clearance Rate\n(Cases Solved)"
                            ),
                            RollingStatItem(
                              isVisible: _statsVisible,
                              targetString: "130%", 
                              label: "Population Coverage\nof Reports"
                            ),
                            // 'Rising' doesn't have a number, so we handle it as simple text
                            RollingStatItem(
                              isVisible: _statsVisible,
                              targetString: "Rising", 
                              label: "Trend Analysis\n2024 - 2025"
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 4. TARGET AUDIENCE (Previously #5)
                Stack(
                  children: [
                    Container(
                      height: 500,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                           image: AssetImage('assets/image/social.jpg'),
                           fit: BoxFit.cover,
                        )
                      ),
                    ),
                    Container(
                      height: 500,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    Container(
                      height: 500,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("TARGET AUDIENCE", style: headerStyle.copyWith(color: Colors.white)),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.all(30),
                            constraints: const BoxConstraints(maxWidth: 900),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24)
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5,
                                    fontFamily: 'Montserrat'),
                                children: [
                                  TextSpan(text: "Targeting "),
                                  TextSpan(
                                      text: "23-39-year-old individuals",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          " living alone, as well as tourists seeking secure and flexible security solutions.\n\nStrapIt will reach users through "),
                                  TextSpan(
                                      text: "Instagram, TikTok",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          " and targeted digital and travel-oriented channels."),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const FooterCombinedSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // HELPER FOR CONSISTENT INFO SECTIONS
  Widget _buildInfoSection({required String title, required String description}) {
    return Column(
      children: [
        // Title matched to headers (No gradient, Blue Accent, Spaced)
        Text(
          title,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 12),
        // Decorative Gradient Underline
        Container(
          width: 50,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.purpleAccent]),
          ),
        ),
        const SizedBox(height: 25),
        // Consistent Body Text - Grey (No ShaderMask)
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18, 
            height: 1.6, 
            fontWeight: FontWeight.w400,
            color: Colors.black54, // Restored to Grey
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------
//  ROLLING NUMBER / SLOT MACHINE EFFECT STAT ITEM
// -----------------------------------------------------------
class RollingStatItem extends StatelessWidget {
  final bool isVisible;
  final String targetString;
  final String label;

  const RollingStatItem({
    super.key,
    required this.isVisible,
    required this.targetString,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Check if it's a numeric stat
    final String numericOnly = targetString.replaceAll(RegExp(r'[^0-9]'), '');
    final bool isNumeric = numericOnly.isNotEmpty;

    // Common Style
    const TextStyle statStyle = TextStyle(
      color: Colors.blueAccent,
      fontSize: 56,
      fontWeight: FontWeight.bold,
      height: 1.1, // Fix height for alignment
    );

    Widget content;

    if (!isNumeric) {
      // Non-numeric case (e.g. "Rising")
      content = AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        child: Text(
          targetString,
          style: statStyle,
        ),
      );
    } else {
      // Numeric Slot Machine Case
      // Count digits to calculate staggered duration
      List<Widget> rowChildren = [];
      int totalDigits = numericOnly.length;
      int currentDigitIdx = 0;

      for (int i = 0; i < targetString.length; i++) {
        String char = targetString[i];
        if (RegExp(r'[0-9]').hasMatch(char)) {
          // It is a digit
          currentDigitIdx++;
          // Staggered Duration: 
          // Base time (500ms) + Stagger based on position
          // Last digit finishes at ~1200ms
          double durationMs = 500 + (700 * (currentDigitIdx / totalDigits));
          
          rowChildren.add(_SpinningDigit(
            targetDigit: int.parse(char),
            duration: Duration(milliseconds: durationMs.toInt()),
            isVisible: isVisible,
            style: statStyle,
          ));
        } else {
          // Static char (comma, +, %)
          rowChildren.add(Text(char, style: statStyle));
        }
      }

      content = AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rowChildren,
        ),
      );
    }

    return Column(
      children: [
        content,
        const SizedBox(height: 10),
        AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _SpinningDigit extends StatefulWidget {
  final int targetDigit;
  final Duration duration;
  final bool isVisible;
  final TextStyle style;

  const _SpinningDigit({
    super.key,
    required this.targetDigit,
    required this.duration,
    required this.isVisible,
    required this.style,
  });

  @override
  State<_SpinningDigit> createState() => _SpinningDigitState();
}

class _SpinningDigitState extends State<_SpinningDigit> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final double _digitHeight = 62.0; // Matches fontSize + slight padding

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    // easeOutCubic gives a nice "settle" effect
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic); 

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_SpinningDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Generate a strip of numbers.
    // Order: [Target, 9, 8, ... 0, 9, 8 ... ]
    // We animate visual offset to move numbers DOWN (Up to Down).
    // This means the strip effectively slides down.
    
    List<int> strip = [];
    strip.add(widget.targetDigit);
    
    // Add 3 cycles of 9..0 to ensure enough length for high speed
    for (int k = 0; k < 3; k++) {
      for (int i = 9; i >= 0; i--) {
        strip.add(i);
      }
    }
    
    double totalHeight = strip.length * _digitHeight;
    
    return SizedBox(
      height: _digitHeight,
      width: 42.0, // Fixed width to prevent jitter
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // Animate from Bottom of strip (hidden randoms) to Top of strip (Target)
            double startOffset = totalHeight - _digitHeight;
            double currentOffset = startOffset * (1.0 - _animation.value);
            
            return Stack(
              children: [
                Positioned(
                  top: -currentOffset, 
                  left: 0, right: 0,
                  child: Column(
                    children: strip.map((d) => SizedBox(
                      height: _digitHeight,
                      child: Center(child: Text('$d', style: widget.style)),
                    )).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String description;
  final double width;

  const TeamMemberCard({
    super.key, 
    required this.name, 
    required this.role, 
    required this.description,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, 
      height: 340, 
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 35,
              child: Icon(Icons.person, color: Colors.grey[400], size: 40)),
          const SizedBox(height: 20),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(role,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.blueAccent, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}