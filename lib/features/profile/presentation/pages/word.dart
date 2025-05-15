// lib/features/words/presentation/pages/words_page.dart
import 'package:buddy/features/home/presentation/pages/dashboard.dart';
import 'package:buddy/features/profile/presentation/pages/profile.dart';
import 'package:flutter/material.dart';

class WordsPage extends StatefulWidget {
  const WordsPage({super.key});

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['All Words', 'Recent', 'Favorites', 'Difficult'];
  
  // Sample word data
  final List<Map<String, dynamic>> _words = [
    {
      'word': 'Apple',
      'definition': 'A round fruit with red, yellow, or green skin and a white inside',
      'category': 'Nouns',
      'isFavorite': true,
      'difficulty': 'Easy',
      'lastSeen': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'word': 'Happy',
      'definition': 'Feeling or showing pleasure or contentment',
      'category': 'Adjectives',
      'isFavorite': false,
      'difficulty': 'Easy',
      'lastSeen': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'word': 'Run',
      'definition': 'Move at a speed faster than a walk, never having both feet on the ground at the same time',
      'category': 'Verbs',
      'isFavorite': true,
      'difficulty': 'Easy',
      'lastSeen': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'word': 'Elephant',
      'definition': 'A very large animal with a long trunk and tusks',
      'category': 'Nouns',
      'isFavorite': false,
      'difficulty': 'Medium',
      'lastSeen': DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      'word': 'Beautiful',
      'definition': 'Pleasing the senses or mind aesthetically',
      'category': 'Adjectives',
      'isFavorite': true,
      'difficulty': 'Medium',
      'lastSeen': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'word': 'Dinosaur',
      'definition': 'A large extinct reptile from the Mesozoic era',
      'category': 'Nouns',
      'isFavorite': true,
      'difficulty': 'Difficult',
      'lastSeen': DateTime.now().subtract(const Duration(hours: 1)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'My Words',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.blue,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          List<Map<String, dynamic>> filteredWords = _words;
          
          if (category == 'Recent') {
            filteredWords = _words
                .where((word) => word['lastSeen'].isAfter(DateTime.now().subtract(const Duration(days: 2))))
                .toList();
          } else if (category == 'Favorites') {
            filteredWords = _words.where((word) => word['isFavorite']).toList();
          } else if (category == 'Difficult') {
            filteredWords = _words.where((word) => word['difficulty'] == 'Difficult').toList();
          }
          
          return _buildWordsList(filteredWords);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new word
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      // bottomNavigationBar: AppBottomNavigation(
      //   currentIndex: 1, // Assuming Words page is the second tab
      //   onTap: (index) {
      //     if (index != 1) {
      //       _navigateToPage(context, index);
      //     }
      //   },
      // ),
    );
  }

  Widget _buildWordsList(List<Map<String, dynamic>> words) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      word['word'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            word['category'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          word['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                          color: word['isFavorite'] ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  word['definition'],
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(word['difficulty']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        word['difficulty'],
                        style: TextStyle(
                          color: _getDifficultyColor(word['difficulty']),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.volume_up, color: Colors.blue, size: 20),
                        SizedBox(width: 16),
                        Icon(Icons.play_circle_outline, color: Colors.green, size: 20),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Difficult':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void _navigateToPage(BuildContext context, int index) {
    Widget page;
    switch (index) {
      case 0:
        page =  const DashboardPage();
        break;
      case 1:
        // Already on Words page
        return;
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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}