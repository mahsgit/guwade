import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/mission.dart';
import '../repositories/rewards_repository.dart';

class GetMissionsUseCase {
  final RewardsRepository repository;

  GetMissionsUseCase(this.repository);

  Future<Either<Failure, List<Mission>>> call() {
    return repository.getMissions();
  }
}
