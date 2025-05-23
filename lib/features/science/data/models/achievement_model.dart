import 'package:buddy/features/science/domain/entities/achievement.dart';

class AchievementModel extends Achievement {
  AchievementModel({
    required String achievementId,
    required String childId,
    required String type,
    required String title,
    required String description,
    required DateTime earnedAt,
    required int streakCount,
    required int totalCorrect,
  }) : super(
          achievementId: achievementId,
          childId: childId,
          type: type,
          title: title,
          description: description,
          earnedAt: earnedAt,
          streakCount: streakCount,
          totalCorrect: totalCorrect,
        );

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      achievementId: json['achievement_id'],
      childId: json['child_id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      earnedAt: DateTime.parse(json['earned_at']),
      streakCount: json['streak_count'],
      totalCorrect: json['total_correct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievement_id': achievementId,
      'child_id': childId,
      'type': type,
      'title': title,
      'description': description,
      'earned_at': earnedAt.toIso8601String(),
      'streak_count': streakCount,
      'total_correct': totalCorrect,
    };
  }
}
