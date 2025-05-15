import 'package:dartz/dartz.dart';
import 'package:camera/camera.dart';
import '../../../../core/error/failures.dart';
import '../entities/emotion_result.dart';

abstract class EmotionDetectionRepository {
  Future<Either<Failure, EmotionResult>> detectEmotion(List<XFile> images);
}
