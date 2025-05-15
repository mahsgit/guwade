import 'package:dartz/dartz.dart';
import 'package:camera/camera.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/emotion_result.dart';
import '../../domain/repositories/emotion_repo_abstract.dart';
import '../datasources/emotion_remote_datasource.dart';

class EmotionDetectionRepositoryImpl implements EmotionDetectionRepository {
  final EmotionDetectionRemoteDataSource remoteDataSource;

  EmotionDetectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, EmotionResult>> detectEmotion(
      List<XFile> images) async {
    try {
      final result = await remoteDataSource.detectEmotion(images);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to detect emotion'));
    }
  }
}
