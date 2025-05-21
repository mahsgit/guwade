import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/storytelling_bloc.dart';
import 'package:buddy/core/constants/colors.dart';

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
              _buildReadStorySection(),
              _buildCategoriesSection(),
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
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return _StoryCard(
                      title: story.title,
                      // subtitle: story.subtitle ?? 'Story',
                      imageUrl: story.imageUrl,
                      onTap: () {
                        // Navigate to story detail page
                        // context.read<StorytellingBloc>().add(
                        //       SelectStory(storyId: story.id),
                        //     );
                        Navigator.pushNamed(context, '/story/detail');
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
                    // subtitle: 'Princess',
                    imageUrl: 'assets/fairy_tale.png',
                    onTap: () => Navigator.pushNamed(context, '/story/detail'),
                  ),
                  _StoryCard(
                    title: 'Queen of Bird',
                    // subtitle: 'Adventure',
                    imageUrl: 'assets/queen_bird.png',
                    onTap: () => Navigator.pushNamed(context, '/story/detail'),
                  ),
                ],
              );
            },
          ),
        ),
      ],
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
  // final String subtitle;
  final String? imageUrl;
  final VoidCallback onTap;

  const _StoryCard({
    required this.title,
    // required this.subtitle,
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
              child: imageUrl != null
                  ? Image.asset(
                      imageUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 48),
                    ),
            ),
            // Story title and subtitle
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   subtitle,
                  //   style: TextStyle(
                  //     color: Colors.grey[600],
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
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