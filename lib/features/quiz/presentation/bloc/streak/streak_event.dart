import 'package:equatable/equatable.dart';

abstract class StreakEvent extends Equatable {
  const StreakEvent();

  @override
  List<Object?> get props => [];
}

class LoadStreakEvent extends StreakEvent {}

class UpdateStreakEvent extends StreakEvent {}
