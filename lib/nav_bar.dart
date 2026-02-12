import 'package:flutter/material.dart';
import 'main.dart';
import 'about_us.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
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
            child: const Text("STRAPIT",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          const Spacer(),
          
          // Navigation Links
          HoverNavBarItem(
            title: "About Us",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
          const HoverNavBarItem(title: "Product"),
          const HoverNavBarItem(title: "Features"),
          const HoverNavBarItem(title: "Pricing"),
          
          const SizedBox(width: 20),
          
          // CTA Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: const Text("Download / Buy",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class HoverNavBarItem extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;

  const HoverNavBarItem({super.key, required this.title, this.onTap});

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
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? Colors.white.withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              color: _isHovered ? Colors.blueAccent : Colors.white,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}