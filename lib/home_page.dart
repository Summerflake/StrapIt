import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'background.dart';

// --- Global Keys for Navigation Scrolling ---
final GlobalKey sectionMainKey = GlobalKey();
final GlobalKey sectionProductKey = GlobalKey();
final GlobalKey sectionFeatureKey = GlobalKey();
final GlobalKey sectionPricingKey = GlobalKey();

class HomePage extends StatefulWidget {
  final String? initialSection;

  const HomePage({super.key, this.initialSection});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSection(widget.initialSection!);
      });
    }
  }

  void _scrollToSection(String section) {
    GlobalKey? target;
    if (section == 'product') target = sectionProductKey;
    if (section == 'features') target = sectionFeatureKey;
    if (section == 'pricing') target = sectionPricingKey;

    if (target != null && target.currentContext != null) {
      Scrollable.ensureVisible(
        target.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: GlobalBackground()),
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(key: sectionMainKey, child: const HeroSection()),
                  
                  // Video Section
                  const VideoSection(),

                  Container(key: sectionProductKey, child: const ProductSection()),
                  Container(key: sectionFeatureKey, child: const FeaturesSection()),
                  Container(key: sectionPricingKey, child: const PricingSection()),
                  const DownloadSection(),
                  const FooterSection(), // Added Footer here
                ],
              ),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: NavBar(isHome: true, scrollController: _scrollController),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 1. HERO SECTION
// ============================================================================
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});
  @override
  State<HeroSection> createState() => _HeroSectionState();
}
class _HeroSectionState extends State<HeroSection> {
  int _currentIdx = 0;
  late Timer _timer;
  final List<Map<String, String>> _heroData = [
    {'image': 'assets/image/hotel.jpg', 'label': 'Hotel room door'},
    {'image': 'assets/image/rental.jpg', 'label': 'Rental apartment'},
    {'image': 'assets/image/dorm.jpg', 'label': 'Dormitory'},
    {'image': 'assets/image/home.jpg', 'label': 'Home Door'},
    {'image': 'assets/image/basement.jpg', 'label': 'Basement Windows'},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if(mounted) setState(() => _currentIdx = (_currentIdx + 1) % _heroData.length);
    });
  }
  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height, 
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: Container(
                key: ValueKey<int>(_currentIdx),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_heroData[_currentIdx]['image']!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("SECURE ANY DOOR", textAlign: TextAlign.center, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                     duration: const Duration(milliseconds: 500),
                     child: Text(_heroData[_currentIdx]['label']!, key: ValueKey<String>(_heroData[_currentIdx]['label']!), style: const TextStyle(fontSize: 24, color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// VIDEO SECTION
// ============================================================================
class VideoSection extends StatelessWidget {
  const VideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "See StrapIt in Action",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
              height: isMobile ? 250 : 500,
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 900),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                  image: AssetImage('assets/image/hotel.jpg'), 
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                         print("Play Video Tapped");
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C853),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.keyboard_arrow_down, size: 30, color: Color(0xFF00C853)),
        ],
      ),
    );
  }
}

// ============================================================================
// 2. PRODUCT SECTION
// ============================================================================
class ProductSection extends StatelessWidget {
  const ProductSection({super.key});
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Column(
        children: [
          const Text("PRODUCT", style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 4)),
          const SizedBox(height: 30),
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const Text(
              "StrapIt is a portable strap-based smart lock that reinforces doors and windows without drilling, replacing existing locks, or causing damage.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, fontSize: 24, height: 1.5, fontWeight: FontWeight.w300),
            ),
          ),
          
          const SizedBox(height: 80),
          if (isMobile)
            Column(
              children: [
                Image.asset('assets/image/explode.jpg', height: 300, fit: BoxFit.contain),
                const SizedBox(height: 20),
                Image.asset('assets/image/clamp.jpg', height: 200, fit: BoxFit.contain),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Expanded(child: Image.asset('assets/image/explode.jpg', height: 500, fit: BoxFit.contain)),
                 const SizedBox(width: 40),
                 Expanded(child: Image.asset('assets/image/clamp.jpg', height: 400, fit: BoxFit.contain)),
              ],
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. FEATURES SECTION (UPDATED)
// ============================================================================
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;
    
    // Updated padding: Remove horizontal padding on parent for Mobile 
    // to allow images to be full width
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 0 : 20),
      child: Column(
        children: [
          const Text("FEATURES", style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 4)),
          const SizedBox(height: 60),
          _buildFeatureRow(isMobile, "1. Portable & Non-Destructive", "No drilling or permanent installation. No need to replace existing locks. Leaves no marks on doors or frames.", "assets/image/human.jpg", false),
          _buildFeatureRow(isMobile, "2. Intrusion Alarm", "Detects forced entry through force sensors. Alarm rings continuously until disabled via app. Forces intruders to leave immediately.", "assets/image/crime.jpg", true),
          _buildFeatureRow(isMobile, "3. App-Controlled Smart Security", "Connects to mobile app. Remote alarm control. Smart protection without smart-lock replacement.", "assets/image/dontknow.jpg", false),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(bool isMobile, String title, String desc, String img, bool isReversed) {
    // 1. Create content widgets
    Widget textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text(desc, style: const TextStyle(fontSize: 18, color: Colors.black54, height: 1.5)),
      ],
    );

    // On mobile, image should be full width, so we might remove the borderRadius or keep it 
    // depending on style. Assuming "fit to screen width" means full bleed (0 margin).
    Widget imageContent = isMobile 
      ? Image.asset(img, height: 300, width: double.infinity, fit: BoxFit.cover)
      : ClipRRect(
          borderRadius: BorderRadius.circular(20), 
          child: Image.asset(img, height: 250, fit: BoxFit.cover)
        );

    // 2. Layout
    if (isMobile) {
      // Mobile: Image full width, Text with padding
      return Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            imageContent,
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: textContent,
            ),
          ],
        ),
      );
    } else {
      // Desktop: Row layout
      return Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Row(
          children: isReversed 
            ? [
                Expanded(child: imageContent), 
                const SizedBox(width: 40), 
                Expanded(child: textContent)
              ]
            : [
                Expanded(child: textContent), 
                const SizedBox(width: 40), 
                Expanded(child: imageContent)
              ],
        ),
      );
    }
  }
}

// ============================================================================
// 4. PRICING SECTION
// ============================================================================
class PricingSection extends StatelessWidget {
  const PricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 1100;
    
    // Components
    Widget priceCorridor = const PriceCorridor();
    Widget pricingCard = Container(
      width: 350,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 10))],
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text("StrapIt", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 10),
          const Text("\$22.70", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 20),
          _checkItem("One-time purchase"),
          _checkItem("No installation cost"),
          _checkItem("No drilling"),
          _checkItem("App-controlled alarm"),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: (){}, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, 
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)
            ),
            child: const Text("BUY NOW"),
          )
        ],
      ),
    );

    return Column(
      children: [
        const Text("PRICING", style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 4)),
        const SizedBox(height: 20),
        const Text(
          "secure, scalable, and affordable,\nfor anyone, anywhere.", 
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.grey)
        ),
        const SizedBox(height: 60),
        
        // Layout: Side-by-Side on Desktop, Stacked on Mobile
        if (isMobile)
          Column(
            children: [
              priceCorridor,
              const SizedBox(height: 60),
              pricingCard,
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              priceCorridor, // Left
              const SizedBox(width: 80),
              pricingCard, // Right
            ],
          ),
        
        const SizedBox(height: 100),
        
        // --- TARGET PARTNER SECTION ---
        const Text("TARGET PARTNERS", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Service, Distribution, and Public Safety Partners",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 40),
        
        // The Rolling Animation Widget
        const PartnerMarquee(),
        
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _checkItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 16, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class PriceCorridor extends StatefulWidget {
  const PriceCorridor({super.key});
  @override
  State<PriceCorridor> createState() => _PriceCorridorState();
}
class _PriceCorridorState extends State<PriceCorridor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _widthAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: const [
              Text("LOW", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)), 
              Text("MID", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)), 
              Text("HIGH", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
            ]
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              return SizedBox(
                height: 80, // Explicit height to prevent overlap
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                     // The Track
                    Container(height: 8, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4))),
                    // The Colored Bar
                    FractionallySizedBox(widthFactor: _widthAnimation.value, child: Container(height: 8, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.purpleAccent]), borderRadius: BorderRadius.circular(4)))),
                    
                    // Points and Labels
                    if (_widthAnimation.value > 0.1) ..._buildPoint(0.1, "\$22.70 (StrapIt)", true),
                    if (_widthAnimation.value > 0.5) ..._buildPoint(0.5, "\$150", false),
                    if (_widthAnimation.value > 0.9) ..._buildPoint(0.9, "\$500", false),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Adjusted to return List of Widgets (Dot + Label) for strict positioning
  List<Widget> _buildPoint(double alignX, String label, bool isActive) {
    return [
      // 1. The Dot (Centered on the bar)
      Align(
        alignment: Alignment(alignX * 2 - 1, 0),
        child: Container(
          width: 16, height: 16,
          decoration: BoxDecoration(
            color: isActive ? Colors.blueAccent : Colors.grey[300], 
            shape: BoxShape.circle, 
            boxShadow: isActive ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)] : []
          ),
        ),
      ),
      // 2. The Label (Positioned strictly below)
      Align(
        alignment: Alignment(alignX * 2 - 1, 0),
        child: Container(
          margin: const EdgeInsets.only(top: 40), // Push label down clearly below dot
          child: Text(
            label, 
            style: TextStyle(
              fontSize: 12, 
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal, 
              color: isActive ? Colors.blueAccent : Colors.grey
            )
          ),
        ),
      )
    ];
  }
}

// ============================================================================
// PARTNER MARQUEE
// ============================================================================
class PartnerMarquee extends StatelessWidget {
  const PartnerMarquee({super.key});

  final List<String> row1 = const [
    "Marriott International", "Hilton Hotels", "Hyatt Hotels", "Best Western", 
    "Choice Hotels", "Wyndham Hotels", "Sonder", "Booking.com", "Expedia Group"
  ];
  final List<String> row2 = const [
    "Tripadvisor", "Kayak", "Travelocity", "Google Travel", "Hotwire", 
    "U.S. Dept of Justice", "Natl Network of Fusion Centers", "U.S. Homeland Security", "NCJRS"
  ];

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
          stops: [0.0, 0.1, 0.9, 1.0], 
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ScrollingRow(items: row1, speed: 40),
          const SizedBox(height: 10),
          _ScrollingRow(items: row2, speed: 50, isReversed: true),
        ],
      ),
    );
  }
}

class _ScrollingRow extends StatefulWidget {
  final List<String> items;
  final int speed;
  final bool isReversed;

  const _ScrollingRow({required this.items, required this.speed, this.isReversed = false});

  @override
  State<_ScrollingRow> createState() => _ScrollingRowState();
}

class _ScrollingRowState extends State<_ScrollingRow> {
  late ScrollController _scrollController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!_scrollController.hasClients) return;
      double step = 20.0 / widget.speed; 
      try {
        if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
           _scrollController.jumpTo(_scrollController.offset + step);
        }
      } catch (e) {
        // Silently catch scroll errors if layout is rebuilding
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
    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        reverse: widget.isReversed, 
        itemBuilder: (context, index) {
          final item = widget.items[index % widget.items.length];
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[700], 
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// 5. DOWNLOAD SECTION (UPDATED)
// ============================================================================
class DownloadSection extends StatelessWidget {
  const DownloadSection({super.key});
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      width: double.infinity,
      color: const Color(0xFF121212),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          const Text("GET THE APP", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          
          // Updated Store Buttons
          if (isMobile)
            Column(
              children: [
                _storeBtn(Icons.apple, "Download on the", "App Store"),
                const SizedBox(height: 15),
                _storeBtn(Icons.android, "GET IT ON", "Google Play"),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                _storeBtn(Icons.apple, "Download on the", "App Store"),
                const SizedBox(width: 20),
                _storeBtn(Icons.android, "GET IT ON", "Google Play")
              ]
            ),
        ],
      ),
    );
  }

  // New Styled Button Widget
  Widget _storeBtn(IconData icon, String subtext, String maintext) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(subtext, style: const TextStyle(color: Colors.white70, fontSize: 9, height: 1.0)),
                  Text(maintext, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.2)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 6. FOOTER SECTION (NEW)
// ============================================================================
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9FAFB), // Light background like reference
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          // Logo & Stakeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: const Icon(Icons.security, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text("StrapIt", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Social Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.camera_alt_outlined), // Instagram placeholder
              const SizedBox(width: 15),
              _socialIcon(Icons.facebook),
              const SizedBox(width: 15),
              _socialIcon(Icons.play_circle_outline), // Youtube placeholder
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Contact Info
          const Text(
            "support@strapit.com", 
            style: TextStyle(color: Colors.blueAccent, fontSize: 16)
          ),
          const SizedBox(height: 10),
          
          // Copyright
          const Text(
            "© 2026 StrapIt. All rights reserved.", 
            style: TextStyle(color: Colors.grey, fontSize: 14)
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return InkWell(
      onTap: (){},
      child: Icon(icon, color: Colors.grey[600], size: 28),
    );
  }
}