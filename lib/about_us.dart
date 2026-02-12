import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'nav_bar.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> with TickerProviderStateMixin {
  // Scroll Controller
  final ScrollController _scrollController = ScrollController();

  // Animation Triggers
  bool _showWhoWeAre = false;
  bool _showMission = false;
  bool _showProblem = false;
  bool _showSocial = false;

  // Team Cards Stagger
  final List<bool> _visibleCards = List.generate(5, (_) => false);

  @override
  void initState() {
    super.initState();
    _triggerTeamAnimation();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _triggerTeamAnimation() {
    for (int i = 0; i < 5; i++) {
      Timer(Duration(milliseconds: 300 * (i + 1)), () {
        if (mounted) {
          setState(() {
            _visibleCards[i] = true;
          });
        }
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    double offset = _scrollController.offset;
    double maxScroll = _scrollController.position.maxScrollExtent;

    // --- TRIGGER THRESHOLDS ---
    if (offset > 100 && !_showWhoWeAre) setState(() => _showWhoWeAre = true);
    if (offset > 400 && !_showMission) setState(() => _showMission = true);
    if (offset > 700 && !_showProblem) setState(() => _showProblem = true);
    if (offset > 1000 && !_showSocial) setState(() => _showSocial = true);

    // --- SAFETY TRIGGER (Force show if at bottom) ---
    if (offset >= maxScroll - 50) {
      if (!_showSocial || !_showProblem) {
        setState(() {
          _showWhoWeAre = true;
          _showMission = true;
          _showProblem = true;
          _showSocial = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // --- LAYER 0: BACKGROUND ---
          const Positioned.fill(child: AnimatedBackground()),

          // --- LAYER 1: CONTENT ---
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const NavBar(),

                  // ------------------------------------------
                  // 1. TEAM INTRODUCTION
                  // ------------------------------------------
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 60),
                    child: SizedBox(
                      width: double.infinity,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildAnimatedCard(0, "XinYu", "Project Manager &\nData Science Lead", "Owns delivery governance and Machine-Learning training."),
                            _buildAnimatedCard(1, "Jiachuan", "Development Lead", "Delivering UI/UX and API integration."),
                            _buildAnimatedCard(2, "XiaoYu", "Community Manager", "Runs user analytics, A/B testing, and UAT prior to CI/CD releases."),
                            _buildAnimatedCard(3, "BangYan", "Marketing Lead", "Leading go-to-market strategy and monetization."),
                            _buildAnimatedCard(4, "ChengAo", "R&D Lead", "In charge of Application architecture and feature alignment."),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------
                  // 2. WHO WE ARE
                  // ------------------------------------------
                  _buildSectionHeader("Who We Are"),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _showWhoWeAre ? 1.0 : 0.0,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutQuad,
                      offset: _showWhoWeAre ? Offset.zero : const Offset(0, 0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300, height: 1.5, fontFamily: 'Roboto'),
                            children: [
                              const TextSpan(text: "We are a team driven by a simple belief: personal safety should be "),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: AnimatedUnderlineText(text: "accessible, adaptable, and effortless.", trigger: _showWhoWeAre, delay: 500),
                              ),
                              const TextSpan(text: "\n\nStrapIt was created to bridge the gap between expensive smart locks and basic mechanical devices, offering reliable security without complexity or permanent installation.\n\n"),
                              const TextSpan(text: "Designed by students and engineers focused on affordable, human-scale security.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  // ------------------------------------------
                  // 3. OUR MISSION
                  // ------------------------------------------
                  _buildSectionHeader("Our Mission"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeInOut,
                        width: _showMission ? 800 : 0,
                        height: 2,
                        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blueAccent.withOpacity(0.0)])),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStaggeredText("Our mission is to empower people to feel secure wherever they stay — at home, in rentals, or while travelling —", delay: 200, isVisible: _showMission),
                        const SizedBox(height: 10),
                        _buildStaggeredText("by delivering a portable, user-controlled security solution that combines physical reinforcement with smart alert technology.", delay: 1000, isVisible: _showMission),
                        const SizedBox(height: 30),
                        _buildStaggeredText("Security should travel with you. StrapIt makes that possible.", delay: 1800, isVisible: _showMission, isBold: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),

                  // ------------------------------------------
                  // 4. THE PROBLEM WE ADDRESS
                  // ------------------------------------------
                  _buildSectionHeader("The Problem We Address"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                    child: _buildStaggeredText(
                      "Urban living, frequent travel, and shared accommodations have increased exposure to unauthorized entry. Existing solutions force users to choose between high cost, permanent installation, or limited protection. Many people remain unprotected simply because current locks are not portable, affordable, or adaptable.",
                      delay: 0,
                      isVisible: _showProblem,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // NEW IMAGE LAYOUT
                  FractionallySizedBox(
                    widthFactor: 0.85,
                    child: Column(
                      children: [
                        // Row for the first two images with FIXED HEIGHT
                        SizedBox(
                          height: 350, 
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch, 
                            children: [
                              Expanded(
                                child: _buildAnimatedImage("assets/image/city.jpg", 0, _showProblem),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildAnimatedImage("assets/image/aboutus.png", 300, _showProblem),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Bottom image (Statistic)
                        SizedBox(
                          height: 350,
                          width: double.infinity,
                          child: _buildAnimatedImage("assets/image/statistic.png", 600, _showProblem),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),

                  // ------------------------------------------
                  // 5. SOCIAL CREDIBILITY
                  // ------------------------------------------
                  _buildSectionHeader("Social Credibility"),
                  
                  // Text Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
                    child: AnimatedOpacity(
                      opacity: _showSocial ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 1000),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26, 
                            fontWeight: FontWeight.w300,
                            height: 2.0, 
                            fontFamily: 'Roboto'
                          ),
                          children: [
                            const TextSpan(text: "Targeting "),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: _buildScalingKeyword(" 20–30-year-old ", _showSocial, 200),
                            ),
                            const TextSpan(text: " individuals living alone, as well as tourists seeking secure and flexible security solutions.\n\nStrapIt will reach users through "),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: _buildScalingKeyword("Instagram ", _showSocial, 600),
                            ),
                            const TextSpan(text: ", "),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: _buildScalingKeyword(" TikTok", _showSocial, 800),
                            ),
                            const TextSpan(text: " and targeted digital and travel-oriented channels."),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --- NEW SOCIAL IMAGE ADDED HERE ---
                  const SizedBox(height: 20),
                  FractionallySizedBox(
                    widthFactor: 0.85,
                    child: SizedBox(
                      height: 400, // Fixed height banner style
                      child: _buildAnimatedImage("assets/image/social.jpg", 1200, _showSocial), // Delayed slightly to appear after text
                    ),
                  ),

                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPERS ---

  Widget _buildAnimatedImage(String assetPath, int delay, bool trigger) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
          final bool isReady = trigger && (delay == 0 || snapshot.connectionState == ConnectionState.done);
          
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: isReady ? 1.0 : 0.0,
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuad,
              transform: Matrix4.translationValues(0, isReady ? 0 : 50, 0), 
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ]
                ),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover, 
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.white10,
                    child: Center(child: Text("Missing: $assetPath", style: const TextStyle(color: Colors.red))),
                  ),
                ),
              ),
            ),
          );
      }
    );
  }

  Widget _buildScalingKeyword(String text, bool trigger, int delay) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        bool showEffect = trigger && snapshot.connectionState == ConnectionState.done;
        
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: showEffect ? 1.15 : 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  text,
                  style: TextStyle(
                    color: showEffect ? Colors.cyanAccent : Colors.white,
                    fontSize: 26,
                    fontWeight: showEffect ? FontWeight.bold : FontWeight.w300,
                    shadows: showEffect ? [
                      const Shadow(blurRadius: 10, color: Colors.cyan, offset: Offset(0,0))
                    ] : [],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }

  Widget _buildStaggeredText(String text, {required int delay, required bool isVisible, bool isBold = false}) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
         final showNow = isVisible && snapshot.connectionState == ConnectionState.done;
         return AnimatedOpacity(
           opacity: showNow ? 1.0 : 0.0,
           duration: const Duration(milliseconds: 600),
           child: AnimatedPadding(
             duration: const Duration(milliseconds: 600),
             padding: showNow ? EdgeInsets.zero : const EdgeInsets.only(top: 20),
             child: Text(
                text,
                style: TextStyle(
                  color: isBold ? Colors.blueAccent : Colors.white,
                  fontSize: isBold ? 26 : 24,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
                  height: 1.5,
                ),
              ),
           ),
         );
      }
    );
  }

  Widget _buildAnimatedCard(int index, String name, String role, String description) {
    return Expanded(
      child: AnimatedOpacity(
        opacity: _visibleCards[index] ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TeamMemberCard(name: name, role: role, description: description),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            shadows: [Shadow(blurRadius: 10.0, color: Colors.blueAccent, offset: Offset(0, 0))],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ANIMATED UNDERLINE TEXT
// ---------------------------------------------------------------------------
class AnimatedUnderlineText extends StatefulWidget {
  final String text;
  final bool trigger;
  final int delay;

  const AnimatedUnderlineText({super.key, required this.text, required this.trigger, this.delay = 0});

  @override
  State<AnimatedUnderlineText> createState() => _AnimatedUnderlineTextState();
}

class _AnimatedUnderlineTextState extends State<AnimatedUnderlineText> {
  double _widthFactor = 0.0;

  @override
  void didUpdateWidget(covariant AnimatedUnderlineText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      Timer(Duration(milliseconds: widget.delay), () {
        if (mounted) setState(() => _widthFactor = 1.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(widget.text, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400, height: 1.5)),
        Positioned(
          bottom: 2, left: 0, right: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  height: 2,
                  width: constraints.maxWidth * _widthFactor,
                  color: Colors.cyanAccent,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// TEAM CARD
// ---------------------------------------------------------------------------
class TeamMemberCard extends StatefulWidget {
  final String name;
  final String role;
  final String description;

  const TeamMemberCard({super.key, required this.name, required this.role, required this.description});

  @override
  State<TeamMemberCard> createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<TeamMemberCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isHovered ? -15 : 0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_isHovered ? 0.08 : 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _isHovered ? Colors.blueAccent.withOpacity(0.5) : Colors.white.withOpacity(0.1), width: 1),
          boxShadow: _isHovered ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))] : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50, height: 50,
              decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
              child: Center(child: Text(widget.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))),
            ),
            const SizedBox(height: 20),
            Text(widget.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(widget.role, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Text(widget.description, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ANIMATED BACKGROUND
// ---------------------------------------------------------------------------
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  Alignment _align1 = Alignment.topLeft;
  Alignment _align2 = Alignment.bottomRight;
  Alignment _align3 = Alignment.topRight;
  Alignment _align4 = Alignment.bottomLeft;
  Alignment _align5 = Alignment.center;
  Alignment _align6 = Alignment.topCenter;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _align1 = _randomAlignment();
          _align2 = _randomAlignment();
          _align3 = _randomAlignment();
          _align4 = _randomAlignment();
          _align5 = _randomAlignment();
          _align6 = _randomAlignment();
        });
      }
    });
  }

  Alignment _randomAlignment() {
    final Random random = Random();
    return Alignment(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1);
  }

  @override
  Widget build(BuildContext context) {
    const double blurSigma = 100.0; 
    return Stack(
      children: [
        Container(color: const Color(0xFF151515)),
        _buildBlob(_align1, Colors.blueAccent.withOpacity(0.4), 400),
        _buildBlob(_align2, Colors.purple.withOpacity(0.4), 400),
        _buildBlob(_align3, Colors.cyanAccent.withOpacity(0.3), 300),
        _buildBlob(_align4, Colors.pinkAccent.withOpacity(0.25), 300),
        _buildBlob(_align5, Colors.indigo.withOpacity(0.5), 250),
        _buildBlob(_align6, Colors.deepOrange.withOpacity(0.2), 200),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }

  Widget _buildBlob(Alignment alignment, Color color, double size) {
    return AnimatedAlign(
      duration: const Duration(seconds: 4),
      curve: Curves.easeInOutSine,
      alignment: alignment,
      child: Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    );
  }
}