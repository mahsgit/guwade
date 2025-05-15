import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class MoodIndicator extends StatelessWidget {
  final String mood;

  const MoodIndicator({
    super.key,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _getMoodColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: _getMoodColor(),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getMoodIcon(),
            color: _getMoodColor(),
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            'Current mood: ${_getMoodText()}',
            style: TextStyle(
              color: _getMoodColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getMoodColor() {
    switch (mood) {
      case 'happy':
        return Colors.amber;
      case 'sad':
        return Colors.blue;
      case 'bored':
        return Colors.grey;
      case 'excited':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }
  
  IconData _getMoodIcon() {
    switch (mood) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'bored':
        return Icons.sentiment_neutral;
      case 'excited':
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.sentiment_satisfied_alt;
    }
  }
  
  String _getMoodText() {
    switch (mood) {
      case 'happy':
        return 'Happy';
      case 'sad':
        return 'Sad';
      case 'bored':
        return 'Bored';
      case 'excited':
        return 'Excited';
      default:
        return 'Neutral';
    }
  }
}
