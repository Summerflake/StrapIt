import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Added for SVG support
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
                  
                  // Combined Download & Footer Section
                  const FooterCombinedSection(), 
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
               child: Image.asset(image, fit: BoxFit.contain),
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
// 3. FEATURES SECTION (UPDATED)
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
          
          const SizedBox(height: 100),
          
          // --- VIDEO STAKEHOLDER (16:9) ---
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 1000),
            child: AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/image/city.jpg'), // Placeholder video thumbnail
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
                  ),
                ),
              ),
            ),
          )
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

    Widget imageContent = isMobile 
      ? Image.asset(img, height: 300, width: double.infinity, fit: BoxFit.cover)
      : ClipRRect(
          borderRadius: BorderRadius.circular(20), 
          child: Image.asset(img, height: 250, fit: BoxFit.cover)
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
// 4. PRICING SECTION
// ============================================================================
class PricingSection extends StatelessWidget {
  const PricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 1100;
    
    // Using the corridor widget from earlier steps
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

    return Column(
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
      constraints: const BoxConstraints(maxWidth: 800), // Increased width for 4 items
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // REMOVED LOW/MID/HIGH labels
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              return SizedBox(
                height: 140, // Increased height to prevent text clipping
                child: Stack(
                  // Remove default alignment to allow specific positioning
                  children: [
                     // The Track
                    Align(
                      alignment: const Alignment(0, -0.3), // Move bar up visually
                      child: Container(
                        height: 8, 
                        width: double.infinity, 
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4))
                      )
                    ),
                    // The Colored Bar
                    Align(
                      alignment: Alignment.centerLeft, // Constrain width from left
                      child: FractionallySizedBox(
                        widthFactor: _widthAnimation.value, 
                        heightFactor: 1.0, // Take full height to allow internal alignment
                        child: Align(
                          alignment: const Alignment(0, -0.3), // Match track vertical position
                          child: Container(
                            height: 8, 
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.purpleAccent]), 
                              borderRadius: BorderRadius.circular(4)
                            )
                          )
                        )
                      )
                    ),
                    
                    // Points and Labels
                    // Distributed approximate positions: 0.1, 0.35, 0.6, 0.85
                    if (_widthAnimation.value > 0.1) ..._buildPoint(0.1, "Supplementary\nLock\n\$10-30", false),
                    if (_widthAnimation.value > 0.35) ..._buildPoint(0.35, "StrapIt\n\$24.90", true),
                    if (_widthAnimation.value > 0.6) ..._buildPoint(0.6, "Smart Door\nAlarm\n\$30-150", false),
                    if (_widthAnimation.value > 0.85) ..._buildPoint(0.85, "Digital Smart\nLock\n\$150-500", false),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPoint(double alignX, String label, bool isActive) {
    // Vertical alignment constants
    const double barAlignY = -0.3;
    const double textAlignY = 0.5; // Lower down for text

    return [
      // 1. The Dot
      Align(
        alignment: Alignment(alignX * 2 - 1, barAlignY),
        child: Container(
          width: 16, height: 16,
          decoration: BoxDecoration(
            color: isActive ? Colors.blueAccent : Colors.grey[300], 
            shape: BoxShape.circle, 
            boxShadow: isActive ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)] : []
          ),
        ),
      ),
      // 2. The Label
      Align(
        alignment: Alignment(alignX * 2 - 1, textAlignY),
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
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const Text("GET THE APP", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
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
            _socialSvgIcon('assets/image/instagram.svg'), // Using SVG for Instagram
            const SizedBox(width: 15),
            _socialIcon(Icons.facebook),
            const SizedBox(width: 15),
            _socialSvgIcon('assets/image/youtube.svg'), // Using SVG for YouTube
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
            // Using SvgPicture.asset as requested
            SvgPicture.asset(
              'assets/image/google-play-icon.svg', 
              width: 30, // Adjusted size to fit container nicely
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