import 'package:equatable/equatable.dart';

abstract class MissionsEvent extends Equatable {
  const MissionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMissionsEvent extends MissionsEvent {}

class UpdateMissionEvent extends MissionsEvent {
  final String missionId;
  final int progress;

  const UpdateMissionEvent({
    required this.missionId,
    required this.progress,
  });

  @override
  List<Object?> get props => [missionId, progress];
}

class AddDiamondsEvent extends MissionsEvent {
  final int amount;

  const AddDiamondsEvent({required this.amount});

  @override
  List<Object?> get props => [amount];
}

class AddXpEvent extends MissionsEvent {
  final int amount;

  const AddXpEvent({required this.amount});

  @override
  List<Object?> get props => [amount];
}
