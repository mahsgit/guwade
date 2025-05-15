class StemVideo {
  final int id;
  final String title;
  final String author;
  final String date;
  final String duration;
  final String thumbnailUrl;
  final String description;
  final bool isCompleted;

  StemVideo({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.duration,
    required this.thumbnailUrl,
    required this.description,
    this.isCompleted = false,
  });
}
