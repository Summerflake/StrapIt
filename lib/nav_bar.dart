import 'package:flutter/material.dart';
import 'main.dart';
import 'about_us.dart';
import 'product_page.dart';
import 'features_page.dart';
import 'pricing_page.dart'; // Import Pricing Page
import 'partners_page.dart'; // Import Partners/Download Page

class NavBar extends StatelessWidget {
  final bool isLightMode;

  const NavBar({super.key, this.isLightMode = false});

  @override
  Widget build(BuildContext context) {
    // Define colors based on mode
    final Color textColor = isLightMode ? Colors.black87 : Colors.white;
    final Color hoverColor = Colors.blueAccent;
    final Color borderColor = isLightMode ? Colors.black12 : Colors.white.withOpacity(0.2);

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 950; // Slightly increased breakpoint for better spacing

        return Container(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 20),
          decoration: BoxDecoration(
            color: isLightMode ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.2),
            border: Border(
              bottom: BorderSide(color: borderColor),
            ),
          ),
          child: Row(
            children: [
              // Logo / Home Link
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainLandingPage()),
                  );
                },
                child: Text(
                  "STRAPIT",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const Spacer(),

              // DESKTOP NAVIGATION
              if (!isMobile) ...[
                HoverNavBarItem(
                  title: "About Us",
                  textColor: textColor,
                  hoverColor: hoverColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsPage())),
                ),
                HoverNavBarItem(
                  title: "Product",
                  textColor: textColor,
                  hoverColor: hoverColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductPage())),
                ),
                HoverNavBarItem(
                  title: "Features",
                  textColor: textColor,
                  hoverColor: hoverColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FeaturesPage())),
                ),
                HoverNavBarItem(
                  title: "Pricing",
                  textColor: textColor,
                  hoverColor: hoverColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PricingPage())),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PartnersPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Download / Buy", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ] 
              // MOBILE NAVIGATION (Hamburger)
              else 
                IconButton(
                  icon: Icon(Icons.menu, color: textColor),
                  onPressed: () => _showMobileMenu(context),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isLightMode ? Colors.white : const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final Color menuTextColor = isLightMode ? Colors.black87 : Colors.white;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMobileMenuItem(context, "About Us", () => const AboutUsPage(), menuTextColor),
              _buildMobileMenuItem(context, "Product", () => const ProductPage(), menuTextColor),
              _buildMobileMenuItem(context, "Features", () => const FeaturesPage(), menuTextColor),
              _buildMobileMenuItem(context, "Pricing", () => const PricingPage(), menuTextColor),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close menu first
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PartnersPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Download / Buy", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileMenuItem(BuildContext context, String title, Widget Function() page, Color color) {
    return ListTile(
      title: Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color.withOpacity(0.5)),
      onTap: () {
        Navigator.pop(context); // Close menu
        Navigator.push(context, MaterialPageRoute(builder: (context) => page()));
      },
    );
  }
}

class HoverNavBarItem extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final Color textColor;
  final Color hoverColor;

  const HoverNavBarItem({
    super.key,
    required this.title,
    this.onTap,
    required this.textColor,
    required this.hoverColor,
  });

  @override
  State<HoverNavBarItem> createState() => _HoverNavBarItemState();
}

class _HoverNavBarItemState extends State<HoverNavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered ? widget.hoverColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              color: _isHovered ? widget.hoverColor : widget.textColor,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}