import 'package:buddy/features/stem/domain/entities/stem_video.dart';
import 'package:flutter/material.dart';

class StemVideoItem extends StatelessWidget {
  final StemVideo video;
  final VoidCallback onTap;

  const StemVideoItem({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Video thumbnail
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(video.thumbnailUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Video info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: ${video.duration}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Completion indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: video.isCompleted
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.green,
                  )
                : null,
            ),
          ],
        ),
      ),
    );
  }
}
