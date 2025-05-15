class EmotionResult {
  final bool isInterested;
  final double confidence;
  final String emotion;

  EmotionResult({
    required this.isInterested,
    required this.confidence,
    required this.emotion,
  });
}