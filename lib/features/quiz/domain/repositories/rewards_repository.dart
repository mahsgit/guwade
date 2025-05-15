import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/quiz/domain/entities/mission.dart';
import 'package:dartz/dartz.dart';

abstract class RewardsRepository {
  Future<Either<Failure, List<Mission>>> getMissions();
  Future<Either<Failure, void>> updateMission(String missionId, int progress);
}
