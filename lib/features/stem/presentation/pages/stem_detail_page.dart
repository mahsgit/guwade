import 'package:buddy/features/stem/domain/entities/stem_video.dart';
import 'package:buddy/features/stem/presentation/widgets/related_video_card.dart';
import 'package:flutter/material.dart';

class StemDetailPage extends StatefulWidget {
  final StemVideo video;

  const StemDetailPage({
    super.key,
    required this.video,
  });

  @override
  State<StemDetailPage> createState() => _StemDetailPageState();
}

class _StemDetailPageState extends State<StemDetailPage> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
        backgroundColor: Colors.teal[200],
        actions: const [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video player
            Stack(
              children: [
                Image.network(
                  widget.video.thumbnailUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 40,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Video info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.video.date,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Author: ${widget.video.author}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // View button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('View'),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.video.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Related Videos:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Related videos
                  const Row(
                    children: [
                      Expanded(
                        child: RelatedVideoCard(
                          title: 'English Paper',
                          price: '\$1.5',
                          likes: 200,
                          color: Colors.pink,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: RelatedVideoCard(
                          title: 'IT paper',
                          price: '\$1.5',
                          likes: 200,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
