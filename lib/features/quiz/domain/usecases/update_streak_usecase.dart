import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/streak.dart';
import '../repositories/streak_repository.dart';

class UpdateStreakUseCase {
  final StreakRepository repository;

  UpdateStreakUseCase(this.repository);

  Future<Either<Failure, Streak>> call() {
    return repository.updateStreak();
  }
}
