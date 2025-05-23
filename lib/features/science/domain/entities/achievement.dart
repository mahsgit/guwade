class Achievement {
  final String achievementId;
  final String childId;
  final String type;
  final String title;
  final String description;
  final DateTime earnedAt;
  final int streakCount;
  final int totalCorrect;

  Achievement({
    required this.achievementId,
    required this.childId,
    required this.type,
    required this.title,
    required this.description,
    required this.earnedAt,
    required this.streakCount,
    required this.totalCorrect,
  });
}
