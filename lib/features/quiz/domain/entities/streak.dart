import 'package:equatable/equatable.dart';

class Streak extends Equatable {
  final int currentStreak;
  final List<bool> daysOfWeek;

  const Streak({
    required this.currentStreak,
    required this.daysOfWeek,
  });

  @override
  List<Object?> get props => [currentStreak, daysOfWeek];
}
