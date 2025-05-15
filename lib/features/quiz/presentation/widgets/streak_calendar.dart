import 'package:flutter/material.dart';

class StreakCalendar extends StatelessWidget {
  final List<bool> daysOfWeek;

  const StreakCalendar({
    super.key,
    required this.daysOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    final dayLabels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              return _buildDayIndicator(
                dayLabels[index],
                index < daysOfWeek.length ? daysOfWeek[index] : false,
              );
            }),
          ),
          const SizedBox(height: 24),
          const Text(
            'Increases if you practice every day and will return to zero if you skip a day!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDayIndicator(String day, bool isCompleted) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.purple : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCompleted ? Colors.purple : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: isCompleted
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                )
              : null,
        ),
      ],
    );
  }
}
