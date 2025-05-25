import 'package:buddy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../navbar/navbar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Trigger profile fetch on page load
    context.read<AuthBloc>().add(GetProfileRequested());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Implement navigation logic based on index
  }

  Widget _buildBody(AuthState state) {
    if (state is ProfileLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProfileLoaded) {
      final user = state.user;
      final birthDate = user.birthDate;
      final currentDate = DateTime.now();
      final age = currentDate.year - birthDate.year;
      final ageDisplay = birthDate.month > currentDate.month ||
              (birthDate.month == currentDate.month &&
                  birthDate.day > currentDate.day)
          ? age - 1
          : age;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to start
          children: [
            // Large illustration at the top
            Image.asset(
              'assets/dashboard-img.png', // Using main.png, update if a different asset is intended
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250, // Adjust height as needed
            ),
            const SizedBox(height: 16), // Spacing after image
            // User info row (Gems, Streak, Greeting, Avatar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gems and Streak
                  Row(
                    children: const [
                      Icon(Icons.diamond,
                          color: Colors.blue, size: 20), // Gems icon
                      SizedBox(width: 4),
                      Text('26',
                          style: TextStyle(
                              fontWeight: FontWeight.bold)), // Gems count
                      SizedBox(width: 16),
                      Icon(Icons.local_fire_department,
                          color: Colors.deepOrange, size: 20), // Streak icon
                      SizedBox(width: 4),
                      Text('🔥',
                          style: TextStyle(
                              fontSize:
                                  16)), // Streak count (using fire emoji for now)
                    ],
                  ),
                  // Greeting and Avatar
                  Row(
                    children: [
                      // Greeting Bubble
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange[100], // Light orange background
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('👋 Hi, ${user.nickname}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                      ),
                      const SizedBox(width: 12),
                      // Avatar
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.orange[100],
                        child: ClipOval(
                          child: Image.asset(
                            'assets/mascot.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ), // Replace with user avatar image if available
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32), // Spacing after user info
            // Horizontal Story Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _HorizontalDashboardCard(
                title: 'Stories', // Example title
                level: 'Level 3', // Example level
                onTap: () {
                  Navigator.pushNamed(
                      context, '/story'); // Keep existing navigation
                },
                colors: const [
                  Colors.purple,
                  Colors.blueAccent
                ], // Example gradient colors (adjust as needed)
              ),
            ),
            const SizedBox(height: 16), // Spacing between cards
            // Horizontal Vocabulary Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _HorizontalDashboardCard(
                title: 'Quizzes', // Example title
                level: 'Level 1', // Example level
                onTap: () {
                  Navigator.pushNamed(
                      context, '/story'); // Keep existing navigation
                },
                colors: const [
                  Colors.pinkAccent,
                  Colors.redAccent
                ], // Example gradient colors (adjust as needed)
              ),
            ),
            const SizedBox(height: 32), // Spacing at the bottom
            // The rest of the body content can go here if needed, ensure padding is handled
          ],
        ),
      );
    } else if (state is ProfileError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const Center(child: Text('No profile data available'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFFE082).withOpacity(0.3),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
          // Main Content Area
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return _buildBody(state);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// New widget for the horizontal dashboard cards
class _HorizontalDashboardCard extends StatelessWidget {
  final String title;
  final String level;
  final VoidCallback onTap;
  final List<Color> colors;

  const _HorizontalDashboardCard({
    required this.title,
    required this.level,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Take full width
        height: 140, // Adjust height as needed
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              // Play Icon
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.3), // Semi-transparent white circle
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow, // Play icon
                    color: Colors.white, // White color
                    size: 40,
                  ),
                ),
              ),
              // Level and Title
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      level,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white
                            .withOpacity(0.8), // Slightly transparent white
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White color
                      ),
                    ),
                  ],
                ),
              ),
              // Image on the right (Placeholder for now, or remove if not needed per image interpretation)
              // You might need to add a specific asset here if the gradient doesn't cover the image area
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Image.asset('assets/some_illustration.png', height: 100), // Example
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// Keep the original _DashboardCard if it's used elsewhere or remove if not.
/*
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
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 60) / 3, // Adjust for 3 cards
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
                borderRadius:
                    BorderRadius.circular(16), // Apply border radius to image
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  height: 90, // Adjust height as needed
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
