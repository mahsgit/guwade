import 'package:equatable/equatable.dart';

class Story extends Equatable {
  final String id;
  final String title;
  final String storyBody;
  final String?
      imageUrl; // Made nullable since it can be null in the API response
  final String category;
  final int viewCount;
  final bool isFeatured;

  const Story({
    required this.id,
    required this.title,
    required this.storyBody,
    this.imageUrl,
    this.category = 'General',
    this.viewCount = 0,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        storyBody,
        imageUrl,
        category,
        viewCount,
        isFeatured,
      ];
}
