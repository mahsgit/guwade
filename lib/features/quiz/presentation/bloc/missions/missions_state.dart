import 'package:buddy/features/quiz/domain/entities/mission.dart';
import 'package:equatable/equatable.dart';

abstract class MissionsState extends Equatable {
  const MissionsState();

  @override
  List<Object?> get props => [];
}

class MissionsInitial extends MissionsState {}

class MissionsLoading extends MissionsState {}

class MissionsLoaded extends MissionsState {
  final List<Mission> missions;
  final int diamonds;
  final int xp;

  const MissionsLoaded({
    required this.missions,
    required this.diamonds,
    required this.xp,
  });

  @override
  List<Object?> get props => [missions, diamonds, xp];
}

class MissionsError extends MissionsState {
  final String message;

  const MissionsError({required this.message});

  @override
  List<Object?> get props => [message];
}
