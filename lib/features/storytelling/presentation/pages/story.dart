import 'package:buddy/features/storytelling/presentation/pages/story_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/storytelling_bloc.dart';

/// StorySelectionPage displays a list of stories and categories.
/// It uses StorytellingBloc for state management.
class StorySelectionPage extends StatefulWidget {
  const StorySelectionPage({super.key});

  @override
  State<StorySelectionPage> createState() => _StorySelectionPageState();
}

class _StorySelectionPageState extends State<StorySelectionPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Story', 'STEM'];
  int _selectedStoryLevel = 5; // Default selected level

  @override
  void initState() {
    super.initState();
    // Load stories when the page is initialized
    context.read<StorytellingBloc>().add(LoadStories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildTabSelector(),
              _buildLevelSelector(),
              if (_selectedTabIndex == 0) _buildReadStorySection(),
              if (_selectedTabIndex == 0) _buildCategoriesSection(),
              if (_selectedTabIndex == 1) _buildStemSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Header with illustration
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
        ),
      ),
    );
  }

  // Tab selector (Story, STEM)
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

  // Level selector (1-6)
  Widget _buildLevelSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          6,
          (index) => GestureDetector(
            onTap: () => setState(() => _selectedStoryLevel = index + 1),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedStoryLevel == index + 1
                    ? Colors.yellow[400]
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.yellow[400]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _selectedStoryLevel == index + 1
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // STEM section - Coming soon message
  Widget _buildStemSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.teal[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal[300]!, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.science,
            size: 64,
            color: Colors.teal[700],
          ),
          const SizedBox(height: 16),
          Text(
            "STEM Contest Coming Soon!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "We're preparing exciting STEM challenges for you. Stay tuned!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.teal[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[200],
              foregroundColor: Colors.teal[800],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Notify Me When Available"),
          ),
        ],
      ),
    );
  }

  // Read a story section
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
          child: BlocBuilder<StorytellingBloc, StorytellingState>(
            builder: (context, state) {
              if (state is StoriesLoading) {
                return const Center(child: CircularProgressIndicator());
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
                    return _StoryCard(
                      title: story.title,
                      imageUrl: story.imageUrl,
                      onTap: () {
                        // Navigate to story detail page with all required parameters
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryDetailPage(
                              storyId: story.id,
                              title: story.title,
                              imageUrl: story.imageUrl ?? '',
                              content: story.storyBody ?? 'No content available',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is StoriesError) {
                return Center(child: Text(state.message));
              }
              
              // Fallback with sample data if no stories are loaded yet
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
                        builder: (context) => const StoryDetailPage(
                          storyId: '1',
                          title: 'Fairy Tale Story',
                          imageUrl: 'assets/fairy_tale.png',
                          content: 'Once upon a time, there was a beautiful princess who lived in a castle. '
                              'She was known throughout the kingdom for her kindness and wisdom. '
                              'One day, a mysterious bird with golden feathers appeared at her window.',
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
                        builder: (context) => const StoryDetailPage(
                          storyId: '2',
                          title: 'Queen of Bird',
                          imageUrl: 'assets/queen_bird.png',
                          content: 'In a magical forest, there lived a magnificent bird with feathers of gold and blue. '
                              'This was no ordinary bird, but the queen of all birds, who could speak the language of humans. '
                              'She watched over the forest and all its creatures with wisdom and care.',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // No stories message
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
        ],
      ),
    );
  }

  // Categories section
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
                imageUrl: 'assets/category_comic.png',
                onTap: () {},
              ),
              _CategoryItem(
                title: "Adventure",
                subtitle: "85 Stories",
                color: Colors.orange[900]!,
                imageUrl: 'assets/category_adventure.png',
                onTap: () {},
              ),
              _CategoryItem(
                title: "Fantasy",
                subtitle: "120 Stories",
                color: Colors.red[900]!,
                imageUrl: 'assets/category_fantasy.png',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Story card widget for displaying a single story.
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
            // Story image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.asset(
                      imageUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 48),
                        );
                      },
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 48),
                    ),
            ),
            // Story title
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category item widget for displaying a category.
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
            // Category content
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
            // Category image
            Positioned(
              right: -10,
              bottom: -10,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage: imageUrl != null ? AssetImage(imageUrl!) : null,
                child: imageUrl == null ? const Icon(Icons.category, color: Colors.white) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
