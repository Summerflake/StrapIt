import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'home_page.dart'; // Imports the Page
import 'about_us.dart';
import 'client_prototype.dart'; // Imports the new Prototype Page

class NavBar extends StatelessWidget {
  final bool isHome;
  final ScrollController? scrollController; // Only required if isHome is true
  final Function(String)? onNavigateToSection; // 接收来自 HomePage 的滚动控制权

  const NavBar({
    super.key, 
    required this.isHome, 
    this.scrollController,
    this.onNavigateToSection,
  });

  @override
  Widget build(BuildContext context) {
    // Breakpoint for mobile/desktop
    bool isMobile = MediaQuery.of(context).size.width < 950;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            border: const Border(
              bottom: BorderSide(color: Colors.black12),
            ),
          ),
          child: Row(
            children: [
              // --- LOGO (HOME LINK) ---
              GestureDetector(
                onTap: () {
                  if (isHome) {
                    // Scroll to Top
                    scrollController?.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                  } else {
                    // Navigate to Home safely and reset stack
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/image/logo.png', height: 50, fit: BoxFit.contain),
                    const SizedBox(width: 10),
                    const Text(
                      "STRAPIT",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),

              // --- DESKTOP NAVIGATION ---
              if (!isMobile) ...[
                _DesktopNavItem(title: "Product", actionId: 'product', isHome: isHome, onNavigateToSection: onNavigateToSection),
                _DesktopNavItem(title: "Features", actionId: 'features', isHome: isHome, onNavigateToSection: onNavigateToSection),
                _DesktopNavItem(title: "Prototype", actionId: 'prototype', isHome: isHome, onNavigateToSection: onNavigateToSection), 
                _DesktopNavItem(title: "About Us", actionId: 'about', isHome: isHome, onNavigateToSection: onNavigateToSection),
                
                const SizedBox(width: 20),
                
                // Download Button 
                ElevatedButton(
                  onPressed: () => _handleNavigation(context, 'pricing', isHome, onNavigateToSection),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Download", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ] 
              // --- MOBILE NAVIGATION ---
              else 
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onPressed: () => _showMobileMenu(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- MOBILE MENU LOGIC ---
  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MobileNavItem(context: context, title: "Product", actionId: "product", isHome: isHome, onNavigateToSection: onNavigateToSection),
              _MobileNavItem(context: context, title: "Features", actionId: "features", isHome: isHome, onNavigateToSection: onNavigateToSection),
              _MobileNavItem(context: context, title: "Prototype", actionId: "prototype", isHome: isHome, onNavigateToSection: onNavigateToSection),
              _MobileNavItem(context: context, title: "About Us", actionId: "about", isHome: isHome, onNavigateToSection: onNavigateToSection),
              
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close menu
                    _handleNavigation(context, 'pricing', isHome, onNavigateToSection);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Download", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// HELPER WIDGETS
// ---------------------------------------------------------------------------

class _DesktopNavItem extends StatefulWidget {
  final String title;
  final String actionId; 
  final bool isHome;
  final Function(String)? onNavigateToSection;

  const _DesktopNavItem({required this.title, required this.actionId, required this.isHome, this.onNavigateToSection});

  @override
  State<_DesktopNavItem> createState() => _DesktopNavItemState();
}

class _DesktopNavItemState extends State<_DesktopNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleNavigation(context, widget.actionId, widget.isHome, widget.onNavigateToSection),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.transparent, 
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              color: _isHovered ? Colors.blueAccent : Colors.black87,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String actionId;
  final bool isHome;
  final Function(String)? onNavigateToSection;

  const _MobileNavItem({
    required this.context,
    required this.title,
    required this.actionId,
    required this.isHome,
    this.onNavigateToSection,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black.withOpacity(0.5)),
      onTap: () {
        Navigator.pop(context); // Close mobile menu first
        _handleNavigation(context, actionId, isHome, onNavigateToSection);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// SHARED NAVIGATION LOGIC
// ---------------------------------------------------------------------------
void _handleNavigation(BuildContext context, String actionId, bool isHome, Function(String)? onNavigateToSection) {
  // 1. Handle "About Us" and "Prototype" (Separate Pages)
  if (actionId == 'about') {
    if (isHome) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AboutUsPage()));
    }
    return;
  }
  
  if (actionId == 'prototype') {
    if (isHome) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientPrototypePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientPrototypePage()));
    }
    return;
  }

  // 2. Handle Scroll Sections (Product, Features, Pricing)
  if (isHome) {
    // 触发传进来的回调函数进行滚动
    if (onNavigateToSection != null) {
      onNavigateToSection(actionId);
    }
  } else {
    // If we are NOT on Home (e.g. About Us or Prototype), navigate to Home with an initial trigger.
    // 核心修复点：采用 pushAndRemoveUntil 彻底清空旧栈，防止页面堆叠产生多个 HomePage 报错
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => HomePage(initialSection: actionId)),
      (route) => false,
    );
  }
}