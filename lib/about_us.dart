import 'package:flutter/material.dart';
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
  
  bool _animationStarted = false;
  final List<bool> _visibleStats = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_animationStarted) return;

    // Check if the stats section is visible on screen
    if (_statsKey.currentContext != null) {
      final RenderBox box = _statsKey.currentContext!.findRenderObject() as RenderBox;
      final Offset position = box.localToGlobal(Offset.zero);
      final double screenHeight = MediaQuery.of(context).size.height;

      // Trigger when the top of the stats section enters the bottom 25% of the viewport
      if (position.dy < screenHeight * 0.85) {
        _startStaggeredAnimation();
      }
    }
  }

  Future<void> _startStaggeredAnimation() async {
    if (!mounted) return;
    setState(() => _animationStarted = true);

    // Reveal items one by one
    for (int i = 0; i < _visibleStats.length; i++) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        setState(() {
          _visibleStats[i] = true;
        });
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

                // 1. WHO WE ARE
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      Text("WHO WE ARE", style: headerStyle),
                      const SizedBox(height: 30),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(fontSize: 22, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black87, fontFamily: 'Montserrat'),
                            children: [
                              TextSpan(
                                text: "Vision: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 24,
                                  foreground: Paint()..shader = const LinearGradient(
                                    colors: <Color>[Colors.blueAccent, Colors.purpleAccent],
                                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                ),
                              ),
                              const TextSpan(text: "A future where security is not fixed to buildings, but moves with people. To secure every space, everywhere. To reimagine security for a mobile world."),
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 2. OUR MISSION
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      Text("OUR MISSION", style: headerStyle),
                      const SizedBox(height: 30),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: const Text(
                          "To make personal security portable, affordable, and effortless, wherever people stay.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, height: 1.6, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 3. TEAM INTRODUCTION
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

                // 4. THE PROBLEM
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

                      // STATS ROW WITH FADE IN
                      // Wrapped in a Container with Key to detect visibility
                      Container(
                        key: _statsKey,
                        child: Wrap(
                          spacing: 60,
                          runSpacing: 40,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildAnimatedStat(0, "60,000+", "Offenses Reported\nin the US"),
                            _buildAnimatedStat(1, "< 20%", "Clearance Rate\n(Cases Solved)"),
                            _buildAnimatedStat(2, "130%", "Population Coverage\nof Reports"),
                            _buildAnimatedStat(3, "Rising", "Trend Analysis\n2024 - 2025"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 5. TARGET AUDIENCE
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

  Widget _buildAnimatedStat(int index, String number, String label) {
    bool isVisible = _visibleStats[index];
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 600),
        offset: isVisible ? Offset.zero : const Offset(0, 0.5),
        curve: Curves.easeOut,
        child: StatItem(number: number, label: label),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String number;
  final String label;

  const StatItem({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 56,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4),
        ),
      ],
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