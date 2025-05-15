import 'package:buddy/features/quiz/domain/entities/streak.dart';
import 'package:equatable/equatable.dart';

abstract class StreakState extends Equatable {
  const StreakState();

  @override
  List<Object?> get props => [];
}

class StreakInitial extends StreakState {}

class StreakLoading extends StreakState {}

class StreakLoaded extends StreakState {
  final Streak streak;

  const StreakLoaded({required this.streak});

  @override
  List<Object?> get props => [streak];
}

class StreakError extends StreakState {
  final String message;

  const StreakError({required this.message});

  @override
  List<Object?> get props => [message];
}
