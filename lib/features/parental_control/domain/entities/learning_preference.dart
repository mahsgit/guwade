import 'package:equatable/equatable.dart';

class LearningPreference extends Equatable {
  final String id;
  final String category;
  final String subject;
  final int priorityLevel; // 1-5, 5 being highest
  final String description;

  const LearningPreference({
    required this.id,
    required this.category,
    required this.subject,
    required this.priorityLevel,
    required this.description,
  });

  @override
  List<Object?> get props => [
    id,
    category,
    subject,
    priorityLevel,
    description,
  ];
}
