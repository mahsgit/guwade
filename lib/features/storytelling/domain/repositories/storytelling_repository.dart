import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/story.dart';
import '../entities/vocabulary.dart';

abstract class StorytellingRepository {
  Future<Either<Failure, List<Story>>> getStories();
  Future<Either<Failure, List<Vocabulary>>> getVocabulary();
}
