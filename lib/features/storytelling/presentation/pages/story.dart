import 'package:buddy/features/home/presentation/pages/dashboard.dart';
import 'package:buddy/features/profile/presentation/pages/profile.dart';
import 'package:buddy/features/profile/presentation/pages/word.dart';
import 'package:buddy/features/stem/presentation/pages/stem_content.dart';
import 'package:buddy/features/storytelling/presentation/pages/story_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/storytelling_bloc.dart';
import '../../domain/entities/story.dart';

class StorySelectionPage extends StatefulWidget {
  const StorySelectionPage({super.key});

  @override
  State<StorySelectionPage> createState() => _StorySelectionPageState();
}

class _StorySelectionPageState extends State<StorySelectionPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Story', 'STEM', 'SMA'];

  @override
  void initState() {
    super.initState();
    context.read<StorytellingBloc>().add(LoadStories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildStoryContent()
                  : _selectedTabIndex == 1
                      ? const Center(child: Text('STEM Content Coming Soon'))
                      : const Center(child: Text('SMA Content Coming Soon')),
            ),
          ],
        ),
      ),
    );
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
                              color: _selectedTabIndex == index
                                  ? Colors.black
                                  : Colors.black54,
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
      case 0:
        return Colors.yellow[200]!;
      case 1:
        return Colors.teal[200]!;
      case 2:
        return Colors.pink[200]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Color _getBackgroundColor() {
    switch (_selectedTabIndex) {
      case 0:
        return Colors.yellow[200]!;
      case 1:
        return Colors.teal[200]!;
      case 2:
        return Colors.pink[200]!;
      default:
        return Colors.yellow[200]!;
    }
  }

  Widget _buildStoryContent() {
    return BlocBuilder<StorytellingBloc, StorytellingState>(
      builder: (context, state) {
        if (state is StoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StoriesLoaded) {
          final stories = state.stories;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Read a story',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 280,
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
                                  storyId: story.id,
                                  title: story.title,
                                  imageUrl: story.imageUrl ?? '',
                                  content: story.storyBody,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
                                  story.imageUrl != null &&
                                          story.imageUrl!.isNotEmpty
                                      ? Image.network(
                                          story.imageUrl!,
                                          width: double.infinity,
                                          height: 280,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: double.infinity,
                                          height: 280,
                                          color: Colors.grey[300],
                                          child:
                                              const Icon(Icons.image, size: 48),
                                        ),
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
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          story.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${story.viewCount} Views',
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
                  ),
                  const SizedBox(height: 24),
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
        } else if (state is StoriesError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildCategories() {
    final categories = [
      {
        'title': "Children's Comic",
        'count': '100 Stories',
        'color': Colors.indigo[900],
        'icon': Icons.book,
      },
      {
        'title': 'Adventure',
        'count': '85 Stories',
        'color': Colors.green[800],
        'icon': Icons.explore,
      },
      {
        'title': 'Science',
        'count': '60 Stories',
        'color': Colors.orange[800],
        'icon': Icons.science,
      },
      {
        'title': 'History',
        'count': '45 Stories',
        'color': Colors.purple[800],
        'icon': Icons.history_edu,
      },
    ];
    return SizedBox(
      height: 80,
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
                  child: Icon(
                    category['icon'] as IconData,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
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
  }
}
