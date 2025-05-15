import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/quiz/domain/entities/streak.dart';
import 'package:dartz/dartz.dart';

abstract class StreakRepository {
  Future<Either<Failure, Streak>> getStreak();
  Future<Either<Failure, Streak>> updateStreak();
}
