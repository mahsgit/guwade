import 'package:flutter/material.dart';
import 'package:buddy/features/storytelling/presentation/pages/story_detail.dart';

class StemSelectionWidget extends StatelessWidget {
  const StemSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16, bottom: 12),
          child: Text(
            'STEM Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildStemCard(
                context,
                title: 'Mathematics',
                description: 'Fun math concepts for young minds',
                color: Colors.blue[700]!,
                icon: Icons.calculate,
                storyId: 'math_story_1',
              ),
              _buildStemCard(
                context,
                title: 'Engineering',
                description: 'Build and create amazing things',
                color: Colors.orange[700]!,
                icon: Icons.construction,
                storyId: 'engineering_story_1',
              ),
              _buildStemCard(
                context,
                title: 'Science',
                description: 'Discover how the world works',
                color: Colors.green[700]!,
                icon: Icons.science,
                storyId: 'science_story_1',
              ),
              _buildStemCard(
                context,
                title: 'Technology',
                description: 'Explore amazing gadgets and computers',
                color: Colors.purple[700]!,
                icon: Icons.computer,
                storyId: 'technology_story_1',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStemCard(
    BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required IconData icon,
    required String storyId,
  }) {
    // Determine if this category is available (for demo, only Math and Engineering are available)
    final bool isAvailable = title == 'Mathematics' || title == 'Engineering';
    
    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          // Navigate to story detail page when clicked
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryDetailPage(
                storyId: storyId,
                title: '$title Story',
                imageUrl: 'assets/${title.toLowerCase()}_story.png',
                content: _getStoryContent(title),
              ),
            ),
          );
        } else {
          // Show coming soon dialog for unavailable categories
          _showComingSoonDialog(context, title);
        }
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
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
            // Category header with icon
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            // Category details
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
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isAvailable)
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
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
              "We're preparing exciting $categoryTitle stories for you. Stay tuned!",
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

  String _getStoryContent(String category) {
    // Sample story content based on category
    switch (category) {
      case 'Mathematics':
        return '''
# The Number Kingdom

Once upon a time, in the magical Number Kingdom, there lived a young prince named Digit. 

Prince Digit loved to count everything he saw - the trees in the royal garden, the stars in the night sky, and even the cookies in the royal kitchen!

One day, the evil Subtraction Sorcerer cast a spell on the kingdom, making all the numbers disappear! Without numbers, no one could tell time, count money, or even bake cookies with the right ingredients.

"I must save our kingdom!" declared Prince Digit. He set off on a journey to find the Addition Wizard, who was said to have the power to bring back all the missing numbers.

Along the way, Prince Digit met the Multiplication Fairy, who taught him that 4 × 5 = 20, and the Division Dragon, who showed him that 10 ÷ 2 = 5.

With his new mathematical knowledge, Prince Digit was able to defeat the Subtraction Sorcerer and restore all the numbers to the kingdom.

From that day on, everyone in the Number Kingdom learned to love mathematics, knowing how important numbers are in everyday life.

The End
''';
      case 'Engineering':
        return '''
# The Bridge Builders

In a small village nestled between two mountains, there lived a clever girl named Maya. 

The village was divided by a rushing river, making it difficult for people to visit friends and family on the other side. During the rainy season, the river became so dangerous that no one could cross it.

Maya loved to build things. She would collect sticks, stones, and vines to create small structures. Her dream was to build a bridge across the river to connect the two sides of the village.

One day, Maya started drawing designs for her bridge. She learned about different shapes and discovered that triangles were very strong. She also experimented with different materials to find out which ones were sturdy enough to withstand the river's current.

With help from the villagers, Maya began building her bridge. They used strong wooden beams arranged in triangular patterns for support. They tested different ways to secure the foundation in the riverbed.

After many weeks of hard work, the bridge was complete! The villagers celebrated as they walked across the river safely for the first time.

Maya had become the village's first engineer, and she went on to design water wheels, better homes, and even a system to bring clean water to everyone.

The End
''';
      default:
        return 'Story coming soon!';
    }
  }
}