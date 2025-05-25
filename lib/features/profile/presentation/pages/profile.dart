import 'package:buddy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buddy/features/navbar/navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final String name = state is ProfileLoaded ? state.user.nickname : "John Doe";

          return SafeArea(
            child: Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD54F),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.brown),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              // Add logout functionality here
                              context.read<AuthBloc>().add(LogoutRequested());
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                            },
                            icon: const Icon(Icons.logout, color: Colors.brown),
                            label: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.brown),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 40, color: Colors.black),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text("Newbie", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _ProfileStat(title: "2+ hours", subtitle: "Total Learn"),
                          _ProfileStat(title: "20", subtitle: "Achievements"),
                          _ProfileStat(title: "2", subtitle: "Stories"),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Overview Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Overview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.4,
                    children: [
                      _OverviewCard(icon: Icons.local_fire_department, label: "0", desc: "Day Streak", color: Colors.orange),
                      _OverviewCard(icon: Icons.timelapse, label: "2 hours", desc: "Hours Spent", color: Colors.grey),
                      _OverviewCard(icon: Icons.emoji_events, label: "Bronze", desc: "Current League", color: Colors.brown),
                      _OverviewCard(icon: Icons.menu_book, label: "20", desc: "Story Learned", color: Colors.blue),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Achievement", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: const [
                      _BadgeIcon(
                        icon: Icons.pets,
                        backgroundColor: Color(0xFFFF4081),
                      ),
                      _BadgeIcon(
                        icon: Icons.emoji_nature,
                        backgroundColor: Color(0xFFFF9800),
                      ),
                      _BadgeIcon(
                        icon: Icons.cruelty_free,
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                      _BadgeIcon(
                        icon: Icons.catching_pokemon,
                        backgroundColor: Color(0xFF9C27B0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 4,
        onTap: (index) {
          if (index != 4) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/dashboard');
                break;
              case 1:
                Navigator.pushNamed(context, '/vocabulary');
                break;
              case 3:
                Navigator.pushNamed(context, '/achievements');
                break;
            }
          }
        },
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ProfileStat({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final Color color;
  const _OverviewCard({required this.icon, required this.label, required this.desc, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          )
        ],
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;

  const _BadgeIcon({
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
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
        size: 24,
      ),
    );
  }
}