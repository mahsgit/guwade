import 'package:buddy/features/storytelling/presentation/pages/story_detail.dart';
import 'package:buddy/features/storytelling/presentation/widgets/story_card.dart';
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

class _StorySelectionPageState extends State<StorySelectionPage> with AutomaticKeepAliveClientMixin {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Story', 'STEM'];
  bool _isLoading = false;
  bool _initialLoadDone = false;

  @override
  bool get wantKeepAlive => true; // Keep the state alive when navigating

  @override
  void initState() {
    super.initState();
    // Only load stories if they haven't been loaded yet
    if (!_initialLoadDone) {
      _loadStories();
    }
  }

  void _loadStories() {
    setState(() {
      _isLoading = true;
    });
    
    // Check if stories are already loaded
    final currentState = context.read<StorytellingBloc>().state;
    if (currentState is StoriesLoaded && currentState.stories.isNotEmpty) {
      setState(() {
        _isLoading = false;
        _initialLoadDone = true;
      });
      return;
    }
    
    // Dispatch the LoadStories event
    context.read<StorytellingBloc>().add(LoadStories());
    
    // Set a fallback timer in case the bloc doesn't respond
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
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
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
          // Add a refresh button
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
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              ),
            );
          },
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
          child: BlocConsumer<StorytellingBloc, StorytellingState>(
            listener: (context, state) {
              // Update loading state based on bloc state
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
              // Show loading indicator
              if (state is StoriesLoading || (_isLoading && !_initialLoadDone)) {
                return _buildLoadingIndicator();
              }
              
              // Show loaded stories
              else if (state is StoriesLoaded) {
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
                        ).then((_) {
                          // This ensures the state is refreshed when returning
                          setState(() {});
                        });
                      },
                    );
                  },
                );
              }
              
              // Show error message
              else if (state is StoriesError) {
                return _buildErrorMessage(state.message);
              }
              
              // Show fallback content with sample data
              return _buildFallbackContent();
            },
          ),
        ),
      ],
    );
  }

  // Loading indicator
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

  // Error message
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

  // Fallback content with sample data
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
                imageUrl: 'assets/comic.png',
                onTap: () => _showCategoryComingSoon(context, "Children's Comic"),
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
  
  // Show category coming soon dialog
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
            // Story image - Using Container with DecorationImage
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: imageUrl != null && imageUrl!.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.grey[300],
              ),
              // Show placeholder icon only if no image URL is provided
              child: imageUrl == null || imageUrl!.isEmpty
                  ? const Icon(Icons.image, size: 48, color: Colors.grey)
                  : null,
            ),
            // Story title with background for better readability
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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
            // Category image - Using Container with DecorationImage
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