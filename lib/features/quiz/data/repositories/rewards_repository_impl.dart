import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/quiz/domain/entities/mission.dart';
import 'package:buddy/features/quiz/domain/repositories/rewards_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RewardsRepositoryImpl implements RewardsRepository {
  static const String _missionsKey = 'MISSIONS_KEY';

  @override
  Future<Either<Failure, List<Mission>>> getMissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final missionsJson = prefs.getString(_missionsKey);

      if (missionsJson != null) {
        final List<dynamic> decoded = json.decode(missionsJson);
        final missions = decoded
            .map((item) => Mission(
                  id: item['id'],
                  title: item['title'],
                  icon: item['icon'],
                  target: item['target'],
                  current: item['current'],
                ))
            .toList();

        return Right(missions);
      }

      // Return default missions if none are saved
      return Right(_getDefaultMissions());
    } catch (e) {
      return Left(CacheFailure('Failed to retrieve missions from cache.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateMission(
      String missionId, int progress) async {
    try {
      final missionsResult = await getMissions();

      return missionsResult.fold(
        (failure) => Left(failure),
        (missions) async {
          final updatedMissions = missions.map((mission) {
            if (mission.id == missionId) {
              return Mission(
                id: mission.id,
                title: mission.title,
                icon: mission.icon,
                target: mission.target,
                current: progress,
              );
            }
            return mission;
          }).toList();

          final prefs = await SharedPreferences.getInstance();
          final encoded = json.encode(updatedMissions
              .map((m) => {
                    'id': m.id,
                    'title': m.title,
                    'icon': m.icon,
                    'target': m.target,
                    'current': m.current,
                  })
              .toList());

          await prefs.setString(_missionsKey, encoded);
          return const Right(null);
        },
      );
    } catch (e) {
      return const Left(CacheFailure('Failed to update mission in cache.'));
    }
  }

  List<Mission> _getDefaultMissions() {
    return [
      const Mission(
        id: 'diamonds',
        title: 'Get 25 Diamonds',
        icon: 'diamond',
        target: 25,
        current: 12,
      ),
      const Mission(
        id: 'xp',
        title: 'Get 40 XP',
        icon: 'lightning',
        target: 40,
        current: 24,
      ),
      const Mission(
        id: 'perfect',
        title: 'Get 2 perfect lessons',
        icon: 'target',
        target: 2,
        current: 0,
      ),
      const Mission(
        id: 'challenge',
        title: 'Complete 1 challenge',
        icon: 'fire',
        target: 1,
        current: 1,
      ),
    ];
  }
}
