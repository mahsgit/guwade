import 'package:equatable/equatable.dart';

class Mission extends Equatable {
  final String id;
  final String title;
  final String icon;
  final int target;
  final int current;

  const Mission({
    required this.id,
    required this.title,
    required this.icon,
    required this.target,
    required this.current,
  });

  double get progress => current / target;

  @override
  List<Object?> get props => [id, title, icon, target, current];
}
