import 'package:buddy/features/home/presentation/widgets/activity.dart';
import 'package:buddy/features/home/presentation/widgets/bottom_nav.dart';
import 'package:buddy/features/home/presentation/widgets/card.dart';
import 'package:buddy/features/profile/presentation/pages/profile.dart';
import 'package:buddy/features/profile/presentation/pages/word.dart';
import 'package:buddy/features/quiz/presentation/pages/quiz_page.dart';
import 'package:buddy/features/storytelling/presentation/pages/story.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();
  int _currentIndex = 0;

  // List of pages to navigate to
  final List<Widget> _pages = [
    const _DashboardContent(),
    const WordsPage(),
    const Scaffold(body: Center(child: Text('Achievements'))),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _currentIndex == 0
          ? _pages[0] // Show dashboard content
          : _pages[_currentIndex], // Show other pages based on index
      bottomNavigationBar: AppBottomNavigation(
        navigationKey: _navKey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// Extracted dashboard content into a separate widget
class _DashboardContent extends StatelessWidget {
  const _DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header illustration
              const SizedBox(height: 20),
              _buildHeaderIllustration(),

              // Stats and greeting
              const SizedBox(height: 16),
              _buildStatsAndGreeting(),

              // Ready to learn section
              const SizedBox(height: 24),
              _buildReadyToLearnSection(),

              // Activity cards
              const SizedBox(height: 16),
              _buildActivityCards(context),

              // Recommended section
              const SizedBox(height: 24),
              _buildRecommendedSection(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIllustration() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/main.png',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildStatsAndGreeting() {
    return Row(
      children: [
        // Stats
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: Colors.amber, size: 16),
            ),
            const SizedBox(width: 4),
            const Text('10', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.diamond, color: Colors.blue, size: 16),
            ),
            const SizedBox(width: 4),
            const Text('5', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),

        const Spacer(),

        // Greeting
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.waving_hand, color: Colors.amber, size: 16),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, abebe ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'UKG Student',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.brown[300],
              child: const Text('B',
                  style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadyToLearnSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to learn?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Continue where you left off',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActivityCard(
            title: 'Read',
            image: 'assets/home.png', // Full image background
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StorySelectionPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ActivityCard(
            title: 'Quiz',
            image: 'assets/main.png', // Full image background
            onTap: () {
              // Navigate to the Quiz page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuizPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        RecommendedLessonCard(
          title: 'Learn to Count',
          subtitle: 'comming soon',
          progress: 0.21,
          color: Colors.amber[100]!,
          icon: Icons.calculate,
          iconColor: Colors.amber[700]!,
          onTap: () {},
        ),
      ],
    );
  }
}
