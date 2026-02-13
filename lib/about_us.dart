import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'nav_bar.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> with TickerProviderStateMixin {
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
        if (mounted) setState(() => _visibleCards[i] = true);
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    double offset = _scrollController.offset;
    
    if (offset > 100 && !_showWhoWeAre) setState(() => _showWhoWeAre = true);
    if (offset > 500 && !_showMission) setState(() => _showMission = true);
    if (offset > 900 && !_showProblem) setState(() => _showProblem = true);
    if (offset > 1300 && !_showSocial) setState(() => _showSocial = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- LAYER 0: BACKGROUND (Blobs + Complex Particles) ---
          const Positioned.fill(child: AnimatedBackground()),

          // --- LAYER 1: CONTENT ---
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 900;
                double horizontalPadding = isMobile ? 20 : 60;

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const NavBar(isLightMode: true),

                      // 1. TEAM INTRODUCTION
                      Padding(
                        padding: EdgeInsets.fromLTRB(horizontalPadding, 40, horizontalPadding, 80),
                        child: isMobile 
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for(int i=0; i<5; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: _buildAnimatedCard(i),
                                  )
                              ],
                            )
                          : SizedBox(
                            width: double.infinity,
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(child: _buildAnimatedCard(0)),
                                  Expanded(child: _buildAnimatedCard(1)),
                                  Expanded(child: _buildAnimatedCard(2)),
                                  Expanded(child: _buildAnimatedCard(3)),
                                  Expanded(child: _buildAnimatedCard(4)),
                                ],
                              ),
                            ),
                          ),
                      ),

                      // 2. WHO WE ARE
                      _buildScrollSection(
                        isMobile: isMobile,
                        trigger: _showWhoWeAre,
                        isImageRight: true,
                        imagePath: "assets/image/aboutus.png",
                        title: "Who We Are",
                        content: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black87, fontSize: 20, height: 1.6, fontFamily: 'Montserrat'),
                            children: [
                              const TextSpan(text: "We are a team driven by a simple belief: personal safety should be "),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: AnimatedUnderlineText(text: "accessible and effortless.", trigger: _showWhoWeAre, delay: 500),
                              ),
                              const TextSpan(text: "\n\nStrapIt bridges the gap between expensive smart locks and basic mechanical devices. Designed by engineers for affordable, human-scale security."),
                            ],
                          ),
                        ),
                      ),

                      // 3. OUR MISSION
                      _buildScrollSection(
                        isMobile: isMobile,
                        trigger: _showMission,
                        isImageRight: false,
                        imagePath: "assets/image/city.jpg",
                        title: "Our Mission",
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStaggeredText("Empowering people to feel secure wherever they stay — at home, rentals, or while traveling.", delay: 200, isVisible: _showMission),
                            const SizedBox(height: 20),
                            _buildStaggeredText("Security should travel with you. StrapIt makes that possible.", delay: 600, isVisible: _showMission, isBold: true),
                          ],
                        ),
                      ),

                      // 4. THE PROBLEM
                      _buildScrollSection(
                        isMobile: isMobile,
                        trigger: _showProblem,
                        isImageRight: true,
                        imagePath: "assets/image/statistic.png",
                        title: "The Problem",
                        content: _buildStaggeredText(
                          "Urban living and shared accommodations have increased exposure to unauthorized entry. Existing solutions are either too expensive or require permanent installation. Many remain unprotected simply because current locks are not portable.",
                          delay: 0,
                          isVisible: _showProblem,
                        ),
                      ),

                      const SizedBox(height: 100),

                      // 5. SOCIAL CREDIBILITY
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader("Social Credibility"),
                            const SizedBox(height: 30),
                            AnimatedOpacity(
                              opacity: _showSocial ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 1000),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w300, height: 1.8),
                                  children: [
                                    const TextSpan(text: "Targeting "),
                                    WidgetSpan(child: _buildScalingKeyword(" 20–30s ", _showSocial, 200)),
                                    const TextSpan(text: " living alone and tourists seeking flexible security. Reaching users through "),
                                    WidgetSpan(child: _buildScalingKeyword(" Instagram & TikTok ", _showSocial, 600)),
                                    const TextSpan(text: " and digital channels."),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 1000),
                              opacity: _showSocial ? 1.0 : 0.0,
                              child: AnimatedSlide(
                                offset: _showSocial ? Offset.zero : const Offset(0, 0.1),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOutQuad,
                                child: Container(
                                  width: double.infinity,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 15))],
                                  ),
                                  child: Image.asset(
                                    "assets/image/social.jpg", 
                                    fit: BoxFit.cover,
                                    height: isMobile ? 250 : 400,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE SECTION BUILDER ---
  Widget _buildScrollSection({
    required bool isMobile,
    required bool trigger,
    required bool isImageRight,
    required String imagePath,
    required String title,
    required Widget content,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 60),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),
        opacity: trigger ? 1.0 : 0.0,
        curve: Curves.easeOut,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 1000),
          offset: trigger ? Offset.zero : const Offset(0, 0.1),
          curve: Curves.easeOutQuad,
          child: isMobile 
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildSectionHeader(title),
                   const SizedBox(height: 20),
                   _buildImageContainer(imagePath),
                   const SizedBox(height: 30),
                   content,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isImageRight) ...[
                    Expanded(child: _buildImageContainer(imagePath)),
                    const SizedBox(width: 60),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSectionHeader(title),
                        const SizedBox(height: 30),
                        content,
                      ],
                    ),
                  ),
                  if (isImageRight) ...[
                    const SizedBox(width: 60),
                    Expanded(child: _buildImageContainer(imagePath)),
                  ],
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(String path) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          path,
          fit: BoxFit.cover, 
          errorBuilder: (c, e, s) => Container(
            height: 200, 
            color: Colors.grey[100], 
            child: const Center(child: Icon(Icons.broken_image, color: Colors.grey))
          ),
        ),
      ),
    );
  }

  Widget _buildScalingKeyword(String text, bool trigger, int delay) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        bool showEffect = trigger && snapshot.connectionState == ConnectionState.done;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: showEffect ? 1.1 : 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),

                child: Text(
                  text,
                  style: TextStyle(
                    color: showEffect ? Colors.blueAccent : Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
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
           duration: const Duration(milliseconds: 800),
           child: Text(
              text,
              style: TextStyle(
                color: isBold ? Colors.blueAccent : Colors.black87,
                fontSize: isBold ? 22 : 20,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
                height: 1.5,
              ),
            ),
         );
      }
    );
  }

  Widget _buildAnimatedCard(int i) {
    List<String> names = ["XinYu", "Jiachuan", "XiaoYu", "BangYan", "ChengAo"];
    List<String> roles = ["Project Manager", "Dev Lead", "Community", "Marketing", "R&D Lead"];
    List<String> descs = ["Data Science & Governance", "UI/UX & API Integration", "Analytics & UAT", "Strategy & Monetization", "Architecture & Features"];

    return AnimatedOpacity(
      opacity: _visibleCards[i] ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TeamMemberCard(name: names[i], role: roles[i], description: descs[i]),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.blueAccent,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
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
        Text(widget.text, style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w400, height: 1.6)),
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
                  color: Colors.blueAccent.withOpacity(0.5),
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
        transform: Matrix4.translationValues(0, _isHovered ? -10 : 0, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _isHovered ? Colors.blueAccent : Colors.grey.withOpacity(0.1), width: 1),
          boxShadow: [
             BoxShadow(
               color: _isHovered ? Colors.blueAccent.withOpacity(0.1) : Colors.black.withOpacity(0.03),
               blurRadius: 20, 
               offset: const Offset(0, 10)
             )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 24,
              child: Text(widget.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            Text(widget.name, style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(widget.role, style: const TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(height: 15),
            Text(widget.description, style: const TextStyle(color: Colors.black54, fontSize: 12, height: 1.4)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ANIMATED BACKGROUND (BLOBS + RESPONSIVE PARTICLES)
// ---------------------------------------------------------------------------
class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _BlobBackground(),
        LayoutBuilder(
          builder: (context, constraints) {
            return _ParticleOverlay(width: constraints.maxWidth, height: constraints.maxHeight);
          },
        ),
      ],
    );
  }
}

class _BlobBackground extends StatefulWidget {
  const _BlobBackground();

  @override
  State<_BlobBackground> createState() => _BlobBackgroundState();
}

class _BlobBackgroundState extends State<_BlobBackground> {
  Alignment _align1 = Alignment.topLeft;
  Alignment _align2 = Alignment.bottomRight;
  Alignment _align3 = Alignment.topRight;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _align1 = _randomAlignment();
          _align2 = _randomAlignment();
          _align3 = _randomAlignment();
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
    return Stack(
      children: [
        Container(color: Colors.white),
        _buildBlob(_align1, Colors.blueAccent.withOpacity(0.05), 500),
        _buildBlob(_align2, Colors.purpleAccent.withOpacity(0.05), 400),
        _buildBlob(_align3, Colors.cyanAccent.withOpacity(0.05), 300),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }

  Widget _buildBlob(Alignment alignment, Color color, double size) {
    return AnimatedAlign(
      duration: const Duration(seconds: 5),
      curve: Curves.easeInOutSine,
      alignment: alignment,
      child: Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    );
  }
}

// --- COMPLEX RESPONSIVE PARTICLE SYSTEM ---

class Particle {
  Offset position;
  Offset velocity;
  double radius;

  Particle({required this.position, required this.velocity, this.radius = 2.0});
}

class _ParticleOverlay extends StatefulWidget {
  final double width;
  final double height;

  const _ParticleOverlay({required this.width, required this.height});

  @override
  State<_ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<_ParticleOverlay> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final List<Particle> _particles = [];
  final Random _random = Random();
  
  // Dynamic Settings
  double _connectionDistance = 150.0;
  
  @override
  void initState() {
    super.initState();
    _initParticles();
    
    _ticker = createTicker((elapsed) {
      _updateParticles();
    });
    _ticker.start();
  }

  @override
  void didUpdateWidget(covariant _ParticleOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.width - oldWidget.width).abs() > 50 || (widget.height - oldWidget.height).abs() > 50) {
      _initParticles();
    }
  }

  void _initParticles() {
    _particles.clear();

    // ---------------------------------------------------------
    // RESPONSIVE LOGIC
    // ---------------------------------------------------------
    bool isMobile = widget.width < 900;

    // Adjusted for "Complex" mobile view
    // Mobile: 35 dots, 110 distance -> Good balance for finding triangles
    int particleCount = isMobile ? 35 : 60; 
    _connectionDistance = isMobile ? 110.0 : 160.0;
    double speedBase = 0.5;

    for (int i = 0; i < particleCount; i++) {
      _particles.add(Particle(
        position: Offset(
          _random.nextDouble() * widget.width,
          _random.nextDouble() * widget.height,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * speedBase,
          (_random.nextDouble() - 0.5) * speedBase,
        ),
        radius: _random.nextDouble() * 2 + 1, 
      ));
    }
  }

  void _updateParticles() {
    setState(() {
      for (var particle in _particles) {
        // Move
        double newX = particle.position.dx + particle.velocity.dx;
        double newY = particle.position.dy + particle.velocity.dy;

        // Bounce off edges
        if (newX < 0 || newX > widget.width) {
          particle.velocity = Offset(-particle.velocity.dx, particle.velocity.dy);
          newX = newX.clamp(0.0, widget.width);
        }
        if (newY < 0 || newY > widget.height) {
          particle.velocity = Offset(particle.velocity.dx, -particle.velocity.dy);
          newY = newY.clamp(0.0, widget.height);
        }

        particle.position = Offset(newX, newY);
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticleNetworkPainter(
        particles: _particles,
        connectionDistance: _connectionDistance, 
      ),
      size: Size(widget.width, widget.height),
    );
  }
}

class ParticleNetworkPainter extends CustomPainter {
  final List<Particle> particles;
  final double connectionDistance;

  ParticleNetworkPainter({required this.particles, required this.connectionDistance});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 1.0;

    final Paint fillPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.05) // Faint fill for shapes
      ..style = PaintingStyle.fill;

    for (int i = 0; i < particles.length; i++) {
      final p1 = particles[i];
      
      // 1. Draw Dot
      canvas.drawCircle(p1.position, p1.radius, dotPaint);

      // Track connection count to fix "lonely dots"
      int connections = 0;
      double closestDist = double.infinity;
      Particle? closestNeighbor;

      // 2. Draw Lines & Triangles
      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];
        final double dist = (p1.position - p2.position).distance;
        
        // Track closest neighbor even if outside range
        if (dist < closestDist) {
          closestDist = dist;
          closestNeighbor = p2;
        }

        // Standard Connection
        if (dist < connectionDistance) {
          connections++;
          
          // Draw Line
          final double opacity = (1 - (dist / connectionDistance)).clamp(0.0, 1.0) * 0.3;
          linePaint.color = Colors.blueGrey.withOpacity(opacity);
          canvas.drawLine(p1.position, p2.position, linePaint);

          // 3. COMPLEX SHAPE LOGIC: TRIANGLE FILL
          // Check if p1 and p2 share a common neighbor p3
          for (int k = j + 1; k < particles.length; k++) {
            final p3 = particles[k];
            final double dist13 = (p1.position - p3.position).distance;
            final double dist23 = (p2.position - p3.position).distance;

            // If a triangle exists (all 3 connected)
            if (dist13 < connectionDistance && dist23 < connectionDistance) {
              final Path path = Path()
                ..moveTo(p1.position.dx, p1.position.dy)
                ..lineTo(p2.position.dx, p2.position.dy)
                ..lineTo(p3.position.dx, p3.position.dy)
                ..close();
              
              canvas.drawPath(path, fillPaint);
            }
          }
        }
      }

      // 4. LONELY DOT FIX
      // If a dot has no connections, force a faint line to its nearest neighbor
      if (connections == 0 && closestNeighbor != null) {
         linePaint.color = Colors.blueGrey.withOpacity(0.05); // Very faint
         canvas.drawLine(p1.position, closestNeighbor.position, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticleNetworkPainter oldDelegate) {
    return true; 
  }
}