import 'package:buddy/features/quiz/presentation/bloc/missions/missions_bloc.dart';
import 'package:buddy/features/quiz/presentation/bloc/missions/missions_event.dart';
import 'package:buddy/features/quiz/presentation/bloc/missions/missions_state.dart';
import 'package:buddy/features/quiz/presentation/pages/streak_page.dart';
import 'package:buddy/features/quiz/presentation/widgets/mission_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  @override
  void initState() {
    super.initState();
    // Load missions when screen initializes
    context.read<MissionsBloc>().add(LoadMissionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily mission updates!'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<MissionsBloc, MissionsState>(
        builder: (context, state) {
          if (state is MissionsLoading || state is MissionsInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is MissionsError) {
            return Center(
              child: Text(state.message),
            );
          }
          
          if (state is MissionsLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ...state.missions.map((mission) => 
                    MissionItem(mission: mission)
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to streak page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StreakPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'CONTINUE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          
          return const Center(
            child: Text('Unexpected state'),
          );
        },
      ),
    );
  }
}
