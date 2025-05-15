import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/emotion_result.dart';
import '../repositories/story_repository.dart';

class DetectEmotionUseCase {
  final StoryRepository repository;

  DetectEmotionUseCase(this.repository);

  Future<Either<Failure, EmotionResult>> call(List<XFile> images) async {
    return await repository.detectEmotion(images);
  }
}
