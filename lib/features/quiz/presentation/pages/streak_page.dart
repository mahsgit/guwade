import 'package:buddy/features/quiz/presentation/bloc/streak/streak_bloc.dart';
import 'package:buddy/features/quiz/presentation/bloc/streak/streak_event.dart';
import 'package:buddy/features/quiz/presentation/bloc/streak/streak_state.dart';
import 'package:buddy/features/quiz/presentation/widgets/streak_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  @override
  void initState() {
    super.initState();
    // Load streak when screen initializes
    context.read<StreakBloc>().add(LoadStreakEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StreakBloc, StreakState>(
        builder: (context, state) {
          if (state is StreakLoading || state is StreakInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is StreakError) {
            return Center(
              child: Text(state.message),
            );
          }
          
          if (state is StreakLoaded) {
            final streak = state.streak;
            
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    size: 64,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${streak.currentStreak} days straight!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 32),
                  StreakCalendar(daysOfWeek: streak.daysOfWeek),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Share functionality
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.purple.shade200),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'SHARE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate back to home
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'CONTINUE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
