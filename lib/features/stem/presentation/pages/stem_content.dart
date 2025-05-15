import 'package:buddy/features/stem/domain/entities/stem_video.dart';
import 'package:buddy/features/stem/presentation/pages/stem_detail_page.dart';
import 'package:buddy/features/stem/presentation/widgets/featured_video_card.dart';
import 'package:buddy/features/stem/presentation/widgets/notes_card.dart';
import 'package:buddy/features/stem/presentation/widgets/stem_video_item.dart';
import 'package:flutter/material.dart';


class StemContent extends StatelessWidget {
  const StemContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'STEM Videos for Kids',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Featured video
            const FeaturedVideoCard(
              title: 'Fun Science Experiments',
              description: 'Learn amazing science facts with fun experiments!',
              duration: '5 min',
              thumbnailUrl: 'https://via.placeholder.com/400x200/4CAF50/FFFFFF?text=Science+Experiments',
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Popular STEM Topics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // STEM videos list
            _buildStemVideosList(context),
            
            const SizedBox(height: 24),
            
            const Text(
              'My Notes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Notes grid
            _buildNotesGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildStemVideosList(BuildContext context) {
    final stemVideos = [
      StemVideo(
        id: 1,
        title: 'Mathematics Tutorial',
        author: 'Professor Math',
        date: '23 February 2022',
        duration: '11 min',
        thumbnailUrl: 'https://via.placeholder.com/400x200/2196F3/FFFFFF?text=Mathematics',
        description: 'Mathematics is the study of numbers, shapes, and patterns. It is essential for understanding the world around us and is used in everyday life. This tutorial covers basic arithmetic, geometry, and problem-solving techniques suitable for kids aged 4-8.',
        isCompleted: true,
      ),
      StemVideo(
        id: 2,
        title: 'IT Programming',
        author: 'Unknown Person',
        date: '21 February 2022',
        duration: '21 min',
        thumbnailUrl: 'https://via.placeholder.com/400x200/00BCD4/FFFFFF?text=IT+Programming',
        description: 'Information technology (IT) is the use of any computers, storage, networking and other physical devices, infrastructure and processes to create, process, store, secure and exchange all forms of electronic data. Typically, IT is used in the context of business operations, as opposed to technology used for personal or entertainment purposes.',
        isCompleted: true,
      ),
      StemVideo(
        id: 3,
        title: 'General Knowledge',
        author: 'Knowledge Master',
        date: '19 February 2022',
        duration: '15 min',
        thumbnailUrl: 'https://via.placeholder.com/400x200/FF9800/FFFFFF?text=General+Knowledge',
        description: 'General knowledge encompasses information across various fields such as science, history, geography, and current events. This video introduces fundamental concepts in an engaging way that\'s perfect for young learners aged 4-8.',
        isCompleted: true,
      ),
    ];

    return Column(
      children: stemVideos.map((video) => 
        StemVideoItem(
          video: video,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StemDetailPage(video: video),
              ),
            );
          },
        )
      ).toList(),
    );
  }

  Widget _buildNotesGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: const [
        NotesCard(
          title: 'English Paper',
          price: '\$1.5',
          likes: 200,
          color: Colors.pink,
        ),
        NotesCard(
          title: 'IT paper',
          price: '\$1.5',
          likes: 200,
          color: Colors.teal,
        ),
      ],
    );
  }
}
