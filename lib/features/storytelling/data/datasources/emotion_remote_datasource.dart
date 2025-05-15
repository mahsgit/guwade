import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import '../../domain/entities/emotion_result.dart';

abstract class EmotionDetectionRemoteDataSource {
  Future<EmotionResult> detectEmotion(List<XFile> images);
}

class EmotionDetectionRemoteDataSourceImpl implements EmotionDetectionRemoteDataSource {
  @override
  Future<EmotionResult> detectEmotion(List<XFile> images) async {
    // Mock implementation since backend is not ready
    // In a real implementation, this would send images to the backend
    
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    // Randomly determine if the child is interested or not
    final random = Random();
    final isInterested = random.nextBool();
    
    return EmotionResult(
      isInterested: isInterested,
      confidence: random.nextDouble() * 100,
      emotion: isInterested ? 'happy' : 'bored',
    );
  }
}
