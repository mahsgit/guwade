import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/story_detail.dart';

class StoryPageView extends StatefulWidget {
  final StoryDetail storyDetail;
  final String currentMood;

  const StoryPageView({
    super.key,
    required this.storyDetail,
    required this.currentMood,
  });

  @override
  State<StoryPageView> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Story title
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.storyDetail.story.title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Page indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.storyDetail.pages.length,
              (index) => Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppColors.primary
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ),
        
        // Page content
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.storyDetail.pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final page = widget.storyDetail.pages[index];
              // Use adapted content based on mood if available
              final content = page.adaptedContent[widget.currentMood] ?? page.content;
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Page image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        page.imageUrl,
                        height: 200.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                    const SizedBox(height: 16.0),
                    
                    // Page content
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 18.0,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        // Navigation buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button
              ElevatedButton(
                onPressed: _currentPage > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios, size: 16.0),
                    SizedBox(width: 4.0),
                    Text('Previous'),
                  ],
                ),
              ),
              
              // Next button
              ElevatedButton(
                onPressed: _currentPage < widget.storyDetail.pages.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Row(
                  children: [
                    Text('Next'),
                    SizedBox(width: 4.0),
                    Icon(Icons.arrow_forward_ios, size: 16.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
