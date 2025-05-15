

import 'package:buddy/features/home/presentation/pages/dashboard.dart';
import 'package:buddy/features/profile/presentation/pages/profile.dart';
import 'package:buddy/features/profile/presentation/pages/word.dart';
import 'package:buddy/features/stem/presentation/pages/stem_content.dart';
import 'package:buddy/features/storytelling/presentation/pages/story_detail.dart';
import 'package:flutter/material.dart';

class StorySelectionPage extends StatefulWidget {
  const StorySelectionPage({super.key});

  @override
  State<StorySelectionPage> createState() => _StorySelectionPageState();
}

class _StorySelectionPageState extends State<StorySelectionPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Story', 'Stem', 'SMA'];
  final int _currentPage = 5;
  final int _totalPages = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with illustration
            _buildHeader(),
            
            // Content based on selected tab
            Expanded(
              child: _selectedTabIndex == 0 
                ? _buildStoryContent() 
                : _selectedTabIndex == 1 
                  ? const StemContent() 
                  : const Center(child: Text('SMA Content Coming Soon')),
            ),
          ],
        ),
      ),
      //  bottomNavigationBar: AppBottomNavigation(
      //   currentIndex: 0,
      //   onTap: (index) {
      //     if (index != 0) {
      //       _navigateToPage(context, index);
      //     }
      //   },
      // ),
    );
  }
   void _navigateToPage(BuildContext context, int index) {
    Widget page;
    switch (index) {
      case 0:
        // Already on Dashboard page
        return;
      case 1:
        page = const WordsPage();
        break;
      case 2:
        // Achievement page
        page = const Scaffold(body: Center(child: Text('Achievements')));
        break;
      case 3:
        page = const ProfilePage();
        break;
      default:
        page =  const DashboardPage();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Color _getBackgroundColor() {

    


    switch (_selectedTabIndex) {
      case 0: // Story
        return Colors.yellow[200]!;
      case 1: // Stem
        return Colors.teal[200]!;
      case 2: // SMA
        return Colors.pink[200]!;
      default:
        return Colors.yellow[200]!;
    }
  }

  Widget _buildHeader() {
    return Container(
       height: 200,
       decoration: BoxDecoration(
         color: Colors.grey[100],
         borderRadius: BorderRadius.circular(16),
       ),
       child: Stack(
         children: [
           ClipRRect(
             borderRadius: BorderRadius.circular(16),
             child: Image.asset(
               'assets/main.png',
               fit: BoxFit.cover,
               width: double.infinity,
             ),
           ),
         
          
          // Tab buttons at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  _tabs.length,
                  (index) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _getTabColor(index),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              color: _selectedTabIndex == index ? Colors.black : Colors.black54,
                              fontWeight: _selectedTabIndex == index ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTabColor(int index) {
    if (_selectedTabIndex != index) {
      return Colors.grey[200]!;
    }
    
    switch (index) {
      case 0: // Story
        return Colors.yellow[200]!;
      case 1: // Stem
        return Colors.teal[200]!;
      case 2: // SMA
        return Colors.pink[200]!;
      default:
        return Colors.grey[200]!;
    }
  }

Widget _buildStoryContent() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // Most watched stories section
          const Text(
            'most watched stories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildMostWatchedStories(),
          
          const SizedBox(height: 24),
          
          // Categories section
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategories(),
          
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

Widget _buildMostWatchedStories() {
  final stories = [
    {
      'title': 'Fairy Tale Story',
      'views': '50K Views',
      'image': 'assets/cinderella.png',
      'color': Colors.blue[900],
      'content': 'Cinderella lived with a wicked step-mother and two step-sisters. Cinderella lived in rags and had to do all the housework.\n\nOne day, the king invited all the young ladies to a ball. Cinderella wanted to go but her step-mother wouldn\'t let her. After they left, her fairy godmother appeared and helped her go to the ball.\n\nAt the ball, Cinderella danced with the prince. At midnight, she had to leave and lost her glass slipper. The prince found it and searched for the owner.\n\nWhen he came to Cinderella\'s house, the slipper fit her perfectly. The prince asked her to marry Prince Charming immediately.'
    },
    {
      'title': 'Queen of Wings',
      'views': '43K Views',
      'image': 'assets/story2.png',
      'color': Colors.orange[800],
      'content': 'In a magical kingdom, there lived a young girl named Aria who dreamed of flying. Every night, she would look up at the stars and wish she had wings.\n\nOne day, while exploring the forest, she found a wounded bird with golden feathers. She nursed it back to health, not knowing it was the Queen of Birds under a spell.\n\nWhen the bird recovered, it revealed its true form and granted Aria a pair of magnificent wings as a reward for her kindness.\n\nAria became known as the Queen of Wings, and she used her gift to help others and protect the kingdom from dangers that came from the skies.'
    },
  ];

  return SizedBox(
    height: 280, // Increased height for larger cards
    child: PageView.builder(
      controller: PageController(viewportFraction: 0.85),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryDetailPage(
                  title: story['title'] as String,
                  imageUrl: story['image'] as String,
                  content: story['content'] as String, storyId: '',
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Story image
                  Image.asset(
                    story['image'] as String,
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                  ),
                  
                  // Gradient overlay for better text visibility
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Title and views overlay
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          story['views'] as String,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildCategories() {
  final categories = [
    {
      'title': 'Children\'s Comic',
      'count': '100 Stories',
      'color': Colors.indigo[900],
      'image': 'assets/story2.png'
    },
    {
      'title': 'Adventure',
      'count': '85 Stories',
      'color': Colors.green[800],
      'image': 'assets/story2.png'
    },
    {
      'title': 'Science',
      'count': '60 Stories',
      'color': Colors.orange[800],
      'image': 'assets/story2.png'
    },
    {
      'title': 'History',
      'count': '45 Stories',
      'color': Colors.purple[800],
      'image': 'assets/story2.png'
    },
  ];

  return SizedBox(
    height: 80, // Reduced height for smaller categories
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Container(
          width: 140,
          margin: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              // Circular category icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: category['color'] as Color,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    category['image'] as String,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Category text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category['title'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      category['count'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}}