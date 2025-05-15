import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/quiz/domain/entities/streak.dart';
import 'package:buddy/features/quiz/domain/repositories/streak_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:shared_preferences/shared_preferences.dart';

class StreakRepositoryImpl implements StreakRepository {
  static const String _streakKey = 'STREAK_KEY';
  static const String _lastUpdatedKey = 'LAST_UPDATED_KEY';

  @override
  Future<Either<Failure, Streak>> getStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final streakValue = prefs.getInt(_streakKey) ?? 0;

      // Create a default week with all days false
      List<bool> daysOfWeek = List.generate(7, (_) => false);

      // Mark days as completed based on streak
      for (int i = 0; i < streakValue && i < 7; i++) {
        daysOfWeek[i] = true;
      }

      return Right(Streak(
        currentStreak: streakValue,
        daysOfWeek: daysOfWeek,
      ));
    } catch (e) {
      return Left(CacheFailure('Failed to retrieve streak data.'));
    }
  }

  @override
  Future<Either<Failure, Streak>> updateStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUpdated = prefs.getString(_lastUpdatedKey);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day).toIso8601String();

      // If already updated today, return current streak
      if (lastUpdated == today) {
        return getStreak();
      }

      // Otherwise increment streak and save today as last updated
      final currentStreak = prefs.getInt(_streakKey) ?? 0;
      final newStreak = currentStreak + 1;

      await prefs.setInt(_streakKey, newStreak);
      await prefs.setString(_lastUpdatedKey, today);

      // Create updated days of week
      List<bool> daysOfWeek = List.generate(7, (_) => false);
      for (int i = 0; i < newStreak && i < 7; i++) {
        daysOfWeek[i] = true;
      }

      return Right(Streak(
        currentStreak: newStreak,
        daysOfWeek: daysOfWeek,
      ));
    } catch (e) {
      return Left(CacheFailure('Failed to update streak data.'));
    }
  }
}
