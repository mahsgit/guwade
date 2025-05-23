import 'package:buddy/features/stem/presentation/pages/stem_content.dart';
import 'package:buddy/features/stem/presentation/pages/stem_detail_page.dart';
import 'package:buddy/features/storytelling/domain/entities/story.dart';
import 'package:buddy/features/storytelling/presentation/pages/story_detail.dart';
import 'package:buddy/features/storytelling/presentation/widgets/story_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/storytelling_bloc.dart';

/// StorySelectionPage displays a list of stories and categories.
/// It uses StorytellingBloc for state management.
class StorySelectionPage extends StatefulWidget {
  const StorySelectionPage({super.key});

  @override
  State<StorySelectionPage> createState() => _StorySelectionPageState();
}

class _StorySelectionPageState extends State<StorySelectionPage>
    with AutomaticKeepAliveClientMixin {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Story', 'STEM'];
  bool _isLoading = false;
  bool _initialLoadDone = false;

  @override
  bool get wantKeepAlive => true; // Keep the state alive when navigating

  @override
  void initState() {
    super.initState();
    if (!_initialLoadDone) {
      _loadStories();
    }
  }

  void _loadStories() {
    setState(() {
      _isLoading = true;
    });

    final currentState = context.read<StorytellingBloc>().state;
    if (currentState is StoriesLoaded && currentState.stories.isNotEmpty) {
      setState(() {
        _isLoading = false;
        _initialLoadDone = true;
      });
      return;
    }

    context.read<StorytellingBloc>().add(LoadStories());

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadStories,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildTabSelector(),
              if (_selectedTabIndex == 0) _buildReadStorySection(),
              if (_selectedTabIndex == 0) _buildCategoriesSection(),
              if (_selectedTabIndex == 1) _buildStemSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/main.png',
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image_not_supported,
                    size: 48, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(
          _tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == index
                      ? index == 0
                          ? Colors.yellow[200]
                          : Colors.teal[200]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: _selectedTabIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStemSection() {
    final List<Map<String, dynamic>> _categories = [
      {
        'id': 'math',
        'title': 'Mathematics',
        'description': 'Fun math concepts for young minds',
        'color': Colors.blue[700]!,
        'icon': Icons.calculate,
        'playlistUrl':
            'https://www.youtube.com/watch?v=a4FXl4zb3E4&list=PLWphMREEQDrgzJPYI_t-DNVb3FjVsMs-K',
        'isAvailable': true,
      },
      {
        'id': 'engineering',
        'title': 'Engineering',
        'description': 'Build and create amazing things',
        'color': Colors.orange[700]!,
        'icon': Icons.construction,
        'playlistUrl':
            'https://www.youtube.com/watch?v=Ra7Bax6rGoQ&list=RDRa7Bax6rGoQ&start_radio=1',
        'isAvailable': true,
      },
      {
        'id': 'science',
        'title': 'Science',
        'description': 'Discover how the world works',
        'color': Colors.green[700]!,
        'icon': Icons.science,
        'playlistUrl': '',
        'isAvailable': false,
      },
      {
        'id': 'technology',
        'title': 'Technology',
        'description': 'Explore amazing gadgets and computers',
        'color': Colors.purple[700]!,
        'icon': Icons.computer,
        'playlistUrl': '',
        'isAvailable': false,
      },
      {
        'id': 'diy',
        'title': 'DIY Projects',
        'description': 'Make your own cool creations',
        'color': Colors.red[700]!,
        'icon': Icons.build,
        'playlistUrl': '',
        'isAvailable': false,
      }
    ];

    return FutureBuilder<Map<String, double>>(
      future: _loadCategoriesProgress(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          );
        }

        final progressMap = snapshot.data ?? {};
        for (var category in _categories) {
          category['progress'] = progressMap[category['id']] ?? 0.0;
        }

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/stem_header.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.teal[200],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.science,
                                      size: 64,
                                      color: Colors.teal[700],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "STEM Learning",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Text(
                            "Explore STEM Subjects",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Colors.amber[700],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "What is STEM?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "STEM stands for Science, Technology, Engineering, and Mathematics. These fun activities help kids learn important skills through play and exploration!",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildInfoChip(Icons.star, "Ages 4-8"),
                        const SizedBox(width: 8),
                        _buildInfoChip(Icons.school, "Kid-friendly"),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "STEM Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return _buildCategoryCard(category, context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, double>> _loadCategoriesProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressMap = <String, double>{};
    for (var category in ['math', 'engineering', 'science', 'technology', 'diy']) {
      progressMap[category] = prefs.getDouble('${category}_progress') ?? 0.0;
    }
    return progressMap;
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.teal[700],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.teal[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (category['isAvailable']) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StemDetailPage(
                category: StemCategory(
                  id: category['id'],
                  title: category['title'],
                  color: category['color'],
                  playlistUrl: category['playlistUrl'],
                ),
              ),
            ),
          ).then((_) => setState(() {})); // Refresh progress on return
        } else {
          _showComingSoonDialog(context, category['title']);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: category['color'].withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  category['icon'],
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!category['isAvailable'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Soon",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.amber[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (category['isAvailable']) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: category['progress'],
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  category['color'],
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${(category['progress'] * 100).toInt()}%",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String categoryTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "$categoryTitle Coming Soon!",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.upcoming,
              size: 64,
              color: Colors.amber[700],
            ),
            const SizedBox(height: 16),
            Text(
              "We're preparing exciting $categoryTitle videos for you. Stay tuned!",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildReadStorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 24, bottom: 16),
          child: Text(
            'read a story',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: BlocConsumer<StorytellingBloc, StorytellingState>(
            listener: (context, state) {
              if (state is StoriesLoading) {
                setState(() {
                  _isLoading = true;
                });
              } else {
                setState(() {
                  _isLoading = false;
                  _initialLoadDone = true;
                });
              }
            },
            builder: (context, state) {
              if (state is StoriesLoading ||
                  (_isLoading && !_initialLoadDone)) {
                return _buildLoadingIndicator();
              } else if (state is StoriesLoaded) {
                final stories = state.stories;
                if (stories.isEmpty) {
                  return _buildNoStoriesMessage();
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return StoryCard(
                      story: story,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryDetailPage(
                              story: story,
                           
                            ),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                    );
                  },
                );
              } else if (state is StoriesError) {
                return _buildErrorMessage(state.message);
              }
              return _buildFallbackContent();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading stories...",
            style: TextStyle(
              color: Colors.amber[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.red[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadStories,
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoStoriesMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No stories available",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadStories,
            icon: const Icon(Icons.refresh),
            label: const Text("Refresh"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackContent() {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _StoryCard(
          title: 'Fairy Tale Story',
          imageUrl: 'assets/fairy_tale.png',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryDetailPage(
                story: Story(
                  id: '1',
                  title: 'Fairy Tale Story',
                  imageUrl: 'assets/fairy_tale.png',
                  storyBody:
                      'Once upon a time, there was a beautiful princess who lived in a castle. '
                      'She was known throughout the kingdom for her kindness and wisdom. '
                      'One day, a mysterious bird with golden feathers appeared at her window.',
                ),
              ),
            ),
          ),
        ),
        _StoryCard(
          title: 'Queen of Bird',
          imageUrl: 'assets/queen_bird.png',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryDetailPage(
                story: Story(
                  id: '2',
                  title: 'Queen of Bird',
                  imageUrl: 'assets/queen_bird.png',
                  storyBody:
                      'In a magical forest, there lived a magnificent bird with feathers of gold and blue. '
                      'This was no ordinary bird, but the queen of all birds, who could speak the language of humans. '
                      'She watched over the forest and all its creatures with wisdom and care.',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 24, bottom: 16),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 24),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _CategoryItem(
                title: "Children's Comic",
                subtitle: "100 Stories",
                color: Colors.indigo[900]!,
                imageUrl: 'assets/comic.png',
                onTap: () =>
                    _showCategoryComingSoon(context, "Children's Comic"),
              ),
              _CategoryItem(
                title: "Adventure",
                subtitle: "85 Stories",
                color: Colors.orange[900]!,
                imageUrl: 'assets/adventure.png',
                onTap: () => _showCategoryComingSoon(context, "Adventure"),
              ),
              _CategoryItem(
                title: "Fantasy",
                subtitle: "120 Stories",
                color: Colors.red[900]!,
                imageUrl: 'assets/fantasy.png',
                onTap: () => _showCategoryComingSoon(context, "Fantasy"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCategoryComingSoon(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "$category Coming Soon!",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.upcoming,
              size: 64,
              color: Colors.amber[700],
            ),
            const SizedBox(height: 16),
            Text(
              "We're preparing exciting $category stories for you. Stay tuned!",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback onTap;

  const _StoryCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                image: imageUrl != null && imageUrl!.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.grey[300],
              ),
              child: imageUrl == null || imageUrl!.isEmpty
                  ? const Icon(Icons.image, size: 48, color: Colors.grey)
                  : null,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String? imageUrl;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -10,
              bottom: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: imageUrl != null
                      ? DecorationImage(
                          image: AssetImage(imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageUrl == null
                    ? const Icon(Icons.category, color: Colors.white, size: 30)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


