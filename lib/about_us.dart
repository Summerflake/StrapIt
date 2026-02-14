import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'background.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 900;
    double horizontalPadding = isMobile ? 20 : 60;
    
    // Calculate card width
    double spacing = 20;
    // Mobile: 1 column (vertical stack), Desktop: 3 columns
    int columns = isMobile ? 1 : 3;
    
    // Total horizontal spacing to subtract from available width
    // For 1 column: 0 spacing. For 3 columns: 2 gaps.
    double totalSpacing = spacing * (columns - 1);
    
    double availableWidth = screenWidth - (horizontalPadding * 2);
    
    // Ensure cardWidth is not negative in edge cases
    double cardWidth = (availableWidth - totalSpacing) / columns;
    if (cardWidth < 100) cardWidth = 100; // Minimum safety width

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: GlobalBackground()),

          SingleChildScrollView(
            child: Column(
              children: [
                const NavBar(isHome: false),

                const SizedBox(height: 60),

                // 1. WHO WE ARE
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      const Text(
                        "WHO WE ARE",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: const Text(
                          "Our vision: A future where security is not fixed to buildings, but moves with people. To secure every space, everywhere. To reimagine security for a mobile world.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, height: 1.6, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 2. TEAM INTRODUCTION
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      const Text(
                        "TEAM INTRODUCTION",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4),
                      ),
                      const SizedBox(height: 40),
                      // Wrap adapts to the cardWidth calculated above
                      Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        alignment: WrapAlignment.center,
                        children: [
                          TeamMemberCard(
                            width: cardWidth,
                            name: "XinYu",
                            role: "Project Manager & DS Lead",
                            description: "Owns delivery governance and Machine-Learning training.",
                          ),
                          TeamMemberCard(
                            width: cardWidth,
                            name: "Jiachuan",
                            role: "R&D Lead",
                            description: "Curates regional food datasets and aligns features with nutrition evidence.",
                          ),
                          TeamMemberCard(
                            width: cardWidth,
                            name: "ChengAo",
                            role: "Application Development",
                            description: "In charge of UI/UX and API integration.",
                          ),
                          TeamMemberCard(
                            width: cardWidth,
                            name: "XiaoYu",
                            role: "Community Manager",
                            description: "Runs user analytics, A/B testing, and UAT prior to CI/CD releases.",
                          ),
                          TeamMemberCard(
                            width: cardWidth,
                            name: "BangYan",
                            role: "Marketing",
                            description: "Leads go-to-market strategy and monetization.",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 3. OUR MISSION
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      const Text(
                        "OUR MISSION",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4),
                      ),
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

                // 4. THE PROBLEM
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: 80, horizontal: horizontalPadding),
                  color: Colors.white.withOpacity(0.5),
                  child: Column(
                    children: [
                      const Text(
                        "THE PROBLEM WE ADDRESS",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: const Text(
                          "Urban living, frequent travel, and shared accommodations have increased exposure to unauthorized entry, while existing solutions force users to choose between high cost, permanent installation, or limited protection. Many people remain unprotected simply because current locks are not portable, affordable, or adaptable.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, height: 1.6, fontWeight: FontWeight.w400, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 50),
                      
                      const Text("Burglary Statistics (2024-2025)",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 40),

                      // STATS ROW
                      Wrap(
                        spacing: 60,
                        runSpacing: 40,
                        alignment: WrapAlignment.center,
                        children: const [
                          StatItem(
                              number: "60,000+",
                              label: "Offenses Reported\nin the US"),
                          StatItem(
                              number: "< 20%",
                              label: "Clearance Rate\n(Cases Solved)"),
                          StatItem(
                              number: "130%",
                              label: "Population Coverage\nof Reports"),
                          StatItem(
                              number: "Rising",
                              label: "Trend Analysis\n2024 - 2025"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 5. TARGET AUDIENCE
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                          child: Text("TARGET AUDIENCE",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4))),
                      const SizedBox(height: 40),
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                  color: Colors.black87,
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
                      ),
                      
                      const SizedBox(height: 60),

                      // --- ADDED IMAGE ---
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20), // Optional rounded corners
                            child: Image.asset(
                              'assets/image/social.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // -------------------
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
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
      height: 340, // Fixed height for uniformity
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
          // Placeholder Avatar
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