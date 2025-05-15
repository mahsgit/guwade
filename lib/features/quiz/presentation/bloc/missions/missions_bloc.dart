import 'package:buddy/features/quiz/domain/entities/mission.dart';
import 'package:buddy/features/quiz/domain/usecases/get_missions_usecase.dart';
import 'package:buddy/features/quiz/domain/usecases/update_mission_usecase.dart';
import 'package:buddy/features/quiz/presentation/bloc/missions/missions_event.dart';
import 'package:buddy/features/quiz/presentation/bloc/missions/missions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissionsBloc extends Bloc<MissionsEvent, MissionsState> {
  final GetMissionsUseCase getMissionsUseCase;
  final UpdateMissionUseCase updateMissionUseCase;

  MissionsBloc({
    required this.getMissionsUseCase,
    required this.updateMissionUseCase,
  }) : super(MissionsInitial()) {
    on<LoadMissionsEvent>(_onLoadMissions);
    on<UpdateMissionEvent>(_onUpdateMission);
    on<AddDiamondsEvent>(_onAddDiamonds);
    on<AddXpEvent>(_onAddXp);
  }

  Future<void> _onLoadMissions(
    LoadMissionsEvent event,
    Emitter<MissionsState> emit,
  ) async {
    emit(MissionsLoading());

    final result = await getMissionsUseCase();

    result.fold(
      (failure) =>
          emit(const MissionsError(message: 'Failed to load missions')),
      (missions) {
        final diamonds = _calculateDiamonds(missions);
        final xp = _calculateXp(missions);

        emit(MissionsLoaded(
          missions: missions,
          diamonds: diamonds,
          xp: xp,
        ));
      },
    );
  }

  Future<void> _onUpdateMission(
    UpdateMissionEvent event,
    Emitter<MissionsState> emit,
  ) async {
    if (state is MissionsLoaded) {
      emit(MissionsLoading());

      final result =
          await updateMissionUseCase(event.missionId, event.progress);

      result.fold(
        (failure) =>
            emit(const MissionsError(message: 'Failed to update mission')),
        (_) async {
          // Reload missions to get updated state
          add(LoadMissionsEvent());
        },
      );
    }
  }

  Future<void> _onAddDiamonds(
    AddDiamondsEvent event,
    Emitter<MissionsState> emit,
  ) async {
    if (state is MissionsLoaded) {
      final currentState = state as MissionsLoaded;

      final diamondMission = currentState.missions.firstWhere(
        (mission) => mission.id == 'diamonds',
        orElse: () => const Mission(
          id: 'diamonds',
          title: 'Get Diamonds',
          icon: 'diamond',
          target: 25,
          current: 0,
        ),
      );

      add(UpdateMissionEvent(
        missionId: 'diamonds',
        progress: diamondMission.current + event.amount,
      ));
    }
  }

  Future<void> _onAddXp(
    AddXpEvent event,
    Emitter<MissionsState> emit,
  ) async {
    if (state is MissionsLoaded) {
      final currentState = state as MissionsLoaded;

      final xpMission = currentState.missions.firstWhere(
        (mission) => mission.id == 'xp',
        orElse: () => const Mission(
          id: 'xp',
          title: 'Get XP',
          icon: 'lightning',
          target: 40,
          current: 0,
        ),
      );

      add(UpdateMissionEvent(
        missionId: 'xp',
        progress: xpMission.current + event.amount,
      ));
    }
  }

  int _calculateDiamonds(List<Mission> missions) {
    final diamondMission = missions.firstWhere(
      (mission) => mission.id == 'diamonds',
      orElse: () => const Mission(
        id: 'diamonds',
        title: 'Get Diamonds',
        icon: 'diamond',
        target: 25,
        current: 0,
      ),
    );

    return diamondMission.current;
  }

  int _calculateXp(List<Mission> missions) {
    final xpMission = missions.firstWhere(
      (mission) => mission.id == 'xp',
      orElse: () => const Mission(
        id: 'xp',
        title: 'Get XP',
        icon: 'lightning',
        target: 40,
        current: 0,
      ),
    );

    return xpMission.current;
  }
}
