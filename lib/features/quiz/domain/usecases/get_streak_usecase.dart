import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/streak.dart';
import '../repositories/streak_repository.dart';

class GetStreakUseCase {
  final StreakRepository repository;

  GetStreakUseCase(this.repository);

  Future<Either<Failure, Streak>> call() {
    return repository.getStreak();
  }
}
