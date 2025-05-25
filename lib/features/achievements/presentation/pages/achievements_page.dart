import 'package:flutter/material.dart';
import 'package:buddy/features/navbar/navbar.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF9C4), // Light yellow
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFFBC02D)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        "Achievement & badges",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFBC02D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // For balance
                  ],
                ),
              ),
              // Achievement Grid
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: const [
                      AchievementBadge(
                        icon: Icons.pets,
                        label: "Super Fast",
                        backgroundColor: Color(0xFFFF4081),
                      ),
                      AchievementBadge(
                        icon: Icons.emoji_nature,
                        label: "Owl Smart",
                        backgroundColor: Color(0xFFFF9800),
                      ),
                      AchievementBadge(
                        icon: Icons.cruelty_free,
                        label: "Bunny Hop",
                        backgroundColor: Color(0xFFFF4081),
                      ),
                      AchievementBadge(
                        icon: Icons.catching_pokemon,
                        label: "Lion Brave",
                        backgroundColor: Color(0xFFFF9800),
                      ),
                      AchievementBadge(
                        icon: Icons.flutter_dash,
                        label: "Bird Focus",
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                      AchievementBadge(
                        icon: Icons.energy_savings_leaf,
                        label: "Bear Strong",
                        backgroundColor: Color(0xFF9C27B0),
                      ),
                      AchievementBadge(
                        icon: Icons.auto_awesome,
                        label: "Fox Clever",
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                      AchievementBadge(
                        icon: Icons.stars,
                        label: "Eagle Eye",
                        backgroundColor: Color(0xFF9C27B0),
                      ),
                      AchievementBadge(
                        icon: Icons.favorite,
                        label: "Kind Heart",
                        backgroundColor: Color(0xFFFF4081),
                      ),
                      AchievementBadge(
                        icon: Icons.psychology,
                        label: "Wise Mind",
                        backgroundColor: Color(0xFFFF9800),
                      ),
                      AchievementBadge(
                        icon: Icons.self_improvement,
                        label: "Zen Master",
                        backgroundColor: Color(0xFFFF4081),
                      ),
                      AchievementBadge(
                        icon: Icons.emoji_emotions,
                        label: "Joy Spark",
                        backgroundColor: Color(0xFFFF9800),
                      ),
                      AchievementBadge(
                        icon: Icons.lightbulb,
                        label: "Bright Idea",
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                      AchievementBadge(
                        icon: Icons.rocket_launch,
                        label: "High Flyer",
                        backgroundColor: Color(0xFF9C27B0),
                      ),
                      AchievementBadge(
                        icon: Icons.diamond,
                        label: "Gem Find",
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                      AchievementBadge(
                        icon: Icons.workspace_premium,
                        label: "Top Star",
                        backgroundColor: Color(0xFF9C27B0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 3,
        onTap: (index) {
          if (index != 3) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/dashboard');
                break;
              case 1:
                Navigator.pushNamed(context, '/vocabulary');
                break;
              case 4:
                Navigator.pushNamed(context, '/profile');
                break;
            }
          }
        },
      ),
    );
  }
}

class AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const AchievementBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: backgroundColor,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
} 