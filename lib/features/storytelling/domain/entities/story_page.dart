import 'package:equatable/equatable.dart';

class StoryPage extends Equatable {
  final int pageNumber;
  final String content;
  final String imageUrl;
  final Map<String, String> adaptedContent; // Mood-based content variations

  const StoryPage({
    required this.pageNumber,
    required this.content,
    required this.imageUrl,
    required this.adaptedContent,
  });

  @override
  List<Object?> get props => [pageNumber, content, imageUrl, adaptedContent];
}

