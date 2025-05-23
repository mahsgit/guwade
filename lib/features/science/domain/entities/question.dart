class Question {
  final String questionId;
  final String chunkId;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String difficultyLevel;
  final String ageRange;
  final String topic;
  final DateTime createdAt;
  final String childId;
  final bool solved;
  final int? selectedAnswer;
  final bool scored;
  final DateTime? answeredAt;
  final int attempts;

  Question({
    required this.questionId,
    required this.chunkId,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.difficultyLevel,
    required this.ageRange,
    required this.topic,
    required this.createdAt,
    required this.childId,
    required this.solved,
    this.selectedAnswer,
    required this.scored,
    this.answeredAt,
    required this.attempts,
  });
}
