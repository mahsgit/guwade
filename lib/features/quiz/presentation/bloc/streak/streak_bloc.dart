import 'package:buddy/features/quiz/domain/usecases/get_streak_usecase.dart';
import 'package:buddy/features/quiz/domain/usecases/update_streak_usecase.dart';
import 'package:buddy/features/quiz/presentation/bloc/streak/streak_event.dart';
import 'package:buddy/features/quiz/presentation/bloc/streak/streak_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final GetStreakUseCase getStreakUseCase;
  final UpdateStreakUseCase updateStreakUseCase;

  StreakBloc({
    required this.getStreakUseCase,
    required this.updateStreakUseCase,
  }) : super(StreakInitial()) {
    on<LoadStreakEvent>(_onLoadStreak);
    on<UpdateStreakEvent>(_onUpdateStreak);
  }

  Future<void> _onLoadStreak(
    LoadStreakEvent event,
    Emitter<StreakState> emit,
  ) async {
    emit(StreakLoading());

    final result = await getStreakUseCase();

    result.fold(
      (failure) => emit(const StreakError(message: 'Failed to load streak')),
      (streak) => emit(StreakLoaded(streak: streak)),
    );
  }

  Future<void> _onUpdateStreak(
    UpdateStreakEvent event,
    Emitter<StreakState> emit,
  ) async {
    emit(StreakLoading());

    final result = await updateStreakUseCase();

    result.fold(
      (failure) => emit(const StreakError(message: 'Failed to update streak')),
      (streak) => emit(StreakLoaded(streak: streak)),
    );
  }
}
