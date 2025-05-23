import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/storytelling/domain/repositories/storytelling_repository.dart';
import 'package:dartz/dartz.dart';

class DetectEmotionusecase {
  final StorytellingRepository repository;

  DetectEmotionusecase(this.repository);

  Future<Either<Failure, String>> call(List<List<int>> frames) async {
    return await repository.detectEmotion(frames);
  }
}