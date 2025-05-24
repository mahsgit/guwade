import 'package:buddy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.brown),
                        onPressed: () => Navigator.pop(context),
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
                    children: [
                      _BadgeImage("assets/slide1.png"),
                      _BadgeImage("assets/slide2.png"),
                      _BadgeImage("assets/slide3.png"),
                      _BadgeImage("assets/home.png"),
                    ],
                  ),
                ),

                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
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

class _BadgeImage extends StatelessWidget {
  final String path;
  const _BadgeImage(this.path);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Image.asset(path, height: 60),
    );
  }
}