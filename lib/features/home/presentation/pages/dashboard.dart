import 'package:buddy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Trigger profile fetch on page load
    context.read<AuthBloc>().add(GetProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = state.user;
            final birthDate = user.birthDate;
            final currentDate = DateTime.now(); // 01:28 AM EAT, May 22, 2025
            final age = currentDate.year - birthDate.year;
            final ageDisplay = birthDate.month > currentDate.month ||
                    (birthDate.month == currentDate.month && birthDate.day > currentDate.day)
                ? age - 1
                : age;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Top illustration
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/main.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180,
                      ),
                    ),
                  ),
                  // User info row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Gems and rank
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.diamond, color: Colors.blue, size: 20),
                                SizedBox(width: 4),
                                Text('26',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text('Rank: 4',
                                style: TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                        // User greeting with dynamic nickname and age
                        Row(
                          children: [
                            Text('👋Hi, ${user.nickname}\n$ageDisplay Years old',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14)),
                            const SizedBox(width: 8),
                            // Avatar
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.orange[100],
                              child: const Icon(Icons.person, color: Colors.brown),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ready to learn
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ready to learn?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Continue where you left off',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Story and Vocabulary cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DashboardCard(
                          image: 'assets/cinderella.png',
                          label: 'Story',
                          onTap: () {
                            Navigator.pushNamed(context, '/story');
                          },
                        ),
                        _DashboardCard(
                          image: 'assets/vocabulary.png',
                          label: 'Vocabulary',
                          onTap: () {
                            Navigator.pushNamed(context, '/vocabulary');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No profile data available'));
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  image,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}