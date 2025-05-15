import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/rewards_repository.dart';

class UpdateMissionUseCase {
  final RewardsRepository repository;

  UpdateMissionUseCase(this.repository);

  Future<Either<Failure, void>> call(String missionId, int progress) {
    return repository.updateMission(missionId, progress);
  }
}
