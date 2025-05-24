import 'package:buddy/features/science/domain/entities/achievement.dart';

class AchievementModel extends Achievement {
  AchievementModel({
    required super.achievementId,
    required super.childId,
    required super.type,
    required super.title,
    required super.description,
    required super.earnedAt,
    required super.streakCount,
    required super.totalCorrect,
  });

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
