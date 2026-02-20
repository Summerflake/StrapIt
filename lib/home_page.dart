import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import 'nav_bar.dart';
import 'background.dart';

class HomePage extends StatefulWidget {
  final String? initialSection;

  const HomePage({super.key, this.initialSection});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  
  // 修复核心：将 GlobalKey 移入 State 内部，防止多次页面入栈时出现 Duplicate GlobalKeys 报错
  final GlobalKey _sectionMainKey = GlobalKey();
  final GlobalKey _sectionProductKey = GlobalKey();
  final GlobalKey _sectionFeatureKey = GlobalKey();
  final GlobalKey _sectionPricingKey = GlobalKey();

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
    if (section == 'product') target = _sectionProductKey;
    if (section == 'features') target = _sectionFeatureKey;
    if (section == 'pricing') target = _sectionPricingKey;

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
                  Container(key: _sectionMainKey, child: const HeroSection()),
                  
                  // Video Section
                  const VideoSection(),

                  Container(key: _sectionProductKey, child: const ProductSection()),
                  Container(key: _sectionFeatureKey, child: const FeaturesSection()),
                  
                  // Pricing 移动到了底部
                  Container(key: _sectionPricingKey, child: const PricingSection()),
                  
                  // Combined Download & Footer Section
                  const FooterCombinedSection(), 
                ],
              ),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: NavBar(
              isHome: true, 
              scrollController: _scrollController,
              onNavigateToSection: _scrollToSection, // 传入回调函数给 NavBar
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 1. HERO SECTION (OPTIMIZED)
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
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _heroData[_currentIdx]['image']!,
                      fit: BoxFit.cover,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) return child;
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                    ),
                    Container(color: Colors.black.withOpacity(0.4)),
                  ],
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
// VIDEO SECTION (OPTIMIZED)
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/image/hotel.jpg',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) return child;
                        return frame == null 
                          ? Container(color: Colors.grey[200]) 
                          : child;
                      },
                    ),
                  ),
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
// 2. PRODUCT SECTION (OPTIMIZED)
// ============================================================================
class ProductSection extends StatelessWidget {
  const ProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 900;

    final List<Map<String, String>> components = [
      {'img': 'assets/image/esp32.jpg', 'name': 'ESP32 Controller'},
      {'img': 'assets/image/rfp602.png', 'name': 'Force Sensor'},
      {'img': 'assets/image/DCMotor.jpg', 'name': 'DC Motor'},
      {'img': 'assets/image/Buzzer.jpg', 'name': 'Piezo Buzzer'},
      {'img': 'assets/image/pushbutton.jpg', 'name': 'Push Buttons'},
      {'img': 'assets/image/holder.jpg', 'name': 'Battery & Holder'},
      {'img': 'assets/image/perfboard.jpg', 'name': 'PCB / Perfboard'},
      {'img': 'assets/image/fiberstrap.jpg', 'name': 'UHMWPE Strap'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Column(
        children: [
          const Text("PRODUCT", style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 4)),
          const SizedBox(height: 40),
          
          Container(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                const Text(
                  "Your space, your rules. No drills, no damage, just total peace of mind.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87, 
                    fontSize: 26, 
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "StrapIt is a portable, non-intrusive smart security device that provides supplemental protection for doors and windows without altering, replacing, or interfering with existing lock mechanisms.\n\nWhether you’re in a city rental, a dorm room, or an Airbnb, StrapIt reinforces your space without a single drill hole. It doesn’t replace your lock, it makes it smarter.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54, 
                    fontSize: 18, 
                    height: 1.6, 
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 80),

          Container(
            width: screenWidth * 0.85,
            constraints: const BoxConstraints(maxHeight: 700),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/image/clamp.jpg', 
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return frame == null 
                    ? Container(color: Colors.grey[200], height: 400) 
                    : child;
                },
              ),
            ),
          ),
          
          const SizedBox(height: 80),

          const Text("HARDWARE COMPONENTS", style: TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 40),

          Container(
            width: screenWidth * 0.85, 
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = isMobile ? 2 : 4; 
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: components.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                     return _ComponentCard(
                       image: components[index]['img']!,
                       name: components[index]['name']!,
                     );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  final String image;
  final String name;

  const _ComponentCard({required this.image, required this.name});

  @override 
  Widget build(BuildContext context) {
     return Container(
       padding: const EdgeInsets.all(10),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(15),
         boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.05),
             blurRadius: 10, 
             offset: const Offset(0,5)
           )
         ],
       ),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Expanded(
             child: ClipRRect(
               borderRadius: BorderRadius.circular(10),
               child: Image.asset(
                 image, 
                 fit: BoxFit.contain,
                 frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                   if (wasSynchronouslyLoaded) return child;
                   return frame == null 
                     ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))) 
                     : child;
                 },
               ),
             ),
           ),
           const SizedBox(height: 12),
           Text(
             name, 
             textAlign: TextAlign.center, 
             style: const TextStyle(
               fontWeight: FontWeight.bold, 
               fontSize: 14, 
               color: Colors.black87
             )
           ),
           const SizedBox(height: 5),
         ],
       ),
     );
  }
}

// ============================================================================
// 3. FEATURES SECTION (OPTIMIZED)
// ============================================================================
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;
    
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
    Widget textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text(desc, style: const TextStyle(fontSize: 18, color: Colors.black54, height: 1.5)),
      ],
    );

    Widget imageContent = GestureDetector(
      onTap: () {
        print("Play feature video for $title");
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(20),
            child: Image.asset(
              img, 
              height: isMobile ? 300 : 250, 
              width: double.infinity,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                 if (wasSynchronouslyLoaded) return child;
                 return frame == null 
                   ? Container(height: isMobile ? 300 : 250, color: Colors.grey[200]) 
                   : child;
              },
            ),
          ),
          Container(
            height: isMobile ? 300 : 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
          ),
        ],
      ),
    );

    if (isMobile) {
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
// 4. PRICING SECTION (MOVED TO BOTTOM)
// ============================================================================
class PricingSection extends StatelessWidget {
  const PricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 1100;
    
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
          const Text("\$24.90", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
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

    return Container(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          const Text("PRICING", style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 4)),
          const SizedBox(height: 20),
          const Text(
            "Unbeatable value compared to traditional solutions.", 
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.grey)
          ),
          const SizedBox(height: 60),
          
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                priceCorridor, 
                const SizedBox(width: 80),
                pricingCard, 
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
          
          const PartnerMarquee(),
          
          const SizedBox(height: 80),
        ],
      ),
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
    bool isMobile = MediaQuery.of(context).size.width < 1100;

    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      height: 150, 
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double trackTop = 70.0; 
          
          return AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: trackTop,
                    left: 0, 
                    right: 0,
                    child: Container(
                      height: 8, 
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4))
                    ),
                  ),
                  
                  Positioned(
                    top: trackTop,
                    left: 0,
                    width: totalWidth * _widthAnimation.value,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.purpleAccent]), 
                        borderRadius: BorderRadius.circular(4)
                      ),
                    ),
                  ),
                  
                  if (_widthAnimation.value > 0.1) ..._buildPositionedPoint(0.1, totalWidth, trackTop, "Supplementary\nLock\n\$10-30", false),
                  if (_widthAnimation.value > 0.21) ..._buildPositionedPoint(0.21, totalWidth, trackTop, "StrapIt\n\$24.90", true, isTop: isMobile),
                  if (_widthAnimation.value > 0.6) ..._buildPositionedPoint(0.6, totalWidth, trackTop, "Smart Door\nAlarm\n\$30-150", false),
                  if (_widthAnimation.value > 0.85) ..._buildPositionedPoint(0.85, totalWidth, trackTop, "Digital Smart\nLock\n\$150-500", false),
                ],
              );
            },
          );
        }
      ),
    );
  }

  List<Widget> _buildPositionedPoint(double alignX, double totalWidth, double trackTop, String label, bool isActive, {bool isTop = false}) {
    const double dotSize = 16.0;
    final double leftPos = totalWidth * alignX;
    final double labelTop = isTop ? trackTop - 55 : trackTop + 20;

    return [
      Positioned(
        left: leftPos - (dotSize / 2),
        top: trackTop + (8 / 2) - (dotSize / 2), 
        child: Container(
          width: dotSize, 
          height: dotSize,
          decoration: BoxDecoration(
            color: isActive ? Colors.blueAccent : Colors.grey[300], 
            shape: BoxShape.circle, 
            boxShadow: isActive ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)] : []
          ),
        ),
      ),
      Positioned(
        left: leftPos - 60, 
        width: 120, 
        top: labelTop, 
        child: Text(
          label, 
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12, 
            height: 1.3,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal, 
            color: isActive ? Colors.blueAccent : Colors.grey
          )
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
// 5. COMBINED DOWNLOAD & FOOTER SECTION
// ============================================================================
class FooterCombinedSection extends StatelessWidget {
  const FooterCombinedSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;

    Widget downloadContent = Column(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        const Text("GET THE APP", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
             _buildAppStoreBtn(),
             const SizedBox(width: 15),
             _buildGooglePlayBtn(),
          ],
        )
      ],
    );

    Widget footerContent = Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.security, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text("StrapIt", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
          children: [
            _socialSvgIcon('assets/image/instagram.svg'), 
            const SizedBox(width: 15),
            _socialIcon(Icons.facebook),
            const SizedBox(width: 15),
            _socialSvgIcon('assets/image/youtube.svg'), 
          ],
        ),
        const SizedBox(height: 20),
        const Text("support@strapit.com", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
        const SizedBox(height: 5),
        const Text("© 2026 StrapIt. All rights reserved.", style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );

    return Container(
      width: double.infinity,
      color: const Color(0xFF121212),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      child: isMobile 
        ? Column(children: [downloadContent, const SizedBox(height: 60), footerContent])
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Expanded(child: downloadContent),
              Expanded(child: footerContent),
            ],
          ),
    );
  }

  Widget _buildAppStoreBtn() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            const Icon(Icons.apple, color: Colors.white, size: 36),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Download on the", style: TextStyle(color: Colors.white, fontSize: 10)),
                Text("App Store", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGooglePlayBtn() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/image/google-play-icon.svg', 
              width: 30, 
              height: 30,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("GET IT ON", style: TextStyle(color: Colors.white, fontSize: 10)),
                Text("Google Play", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return InkWell(
      onTap: (){},
      child: Icon(icon, color: Colors.grey[600], size: 28),
    );
  }

  Widget _socialSvgIcon(String assetPath) {
    return InkWell(
      onTap: (){},
      child: SvgPicture.asset(
        assetPath,
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
      ),
    );
  }
}