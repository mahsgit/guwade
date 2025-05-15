import '../../domain/entities/story.dart';

class StoryModel extends Story {
  const StoryModel({
    required super.id,
    required super.title,
    required super.storyBody,
    super.imageUrl,
    super.category,
    super.viewCount,
    super.isFeatured,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    // Generate id from title since API doesn't provide one
    final String id =
        json['title'].toString().toLowerCase().replaceAll(' ', '-');

    return StoryModel(
      id: id,
      title: json['title'] as String,
      storyBody: json['story_body'] as String,
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String? ?? 'General',
      viewCount: json['view_count'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'story_body': storyBody,
        'image_url': imageUrl,
        'category': category,
        'view_count': viewCount,
        'is_featured': isFeatured,
      };
}
