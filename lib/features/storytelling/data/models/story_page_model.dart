import '../../domain/entities/story_page.dart';

class StoryPageModel extends StoryPage {
  const StoryPageModel({
    required super.pageNumber,
    required super.content,
    required super.imageUrl,
    required super.adaptedContent,
  });

  factory StoryPageModel.fromJson(Map<String, dynamic> json) {
    return StoryPageModel(
      pageNumber: json['page_number'],
      content: json['content'],
      imageUrl: json['image_url'],
      adaptedContent: Map<String, String>.from(json['adapted_content']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNumber,
      'content': content,
      'image_url': imageUrl,
      'adapted_content': adaptedContent,
    };
  }
}
