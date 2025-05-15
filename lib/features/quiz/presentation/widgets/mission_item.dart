import 'package:buddy/features/quiz/domain/entities/mission.dart';
import 'package:flutter/material.dart';

class MissionItem extends StatelessWidget {
  final Mission mission;

  const MissionItem({
    super.key,
    required this.mission,
  });

  @override
  Widget build(BuildContext context) {
    final progress = mission.progress;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mission.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${mission.current}/${mission.target}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.purple,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;
    
    switch (mission.icon) {
      case 'diamond':
        iconData = Icons.diamond;
        iconColor = Colors.blue;
        break;
      case 'lightning':
        iconData = Icons.bolt;
        iconColor = Colors.orange;
        break;
      case 'target':
        iconData = Icons.tablet;
        iconColor = Colors.red;
        break;
      case 'fire':
        iconData = Icons.local_fire_department;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.star;
        iconColor = Colors.amber;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }
}
