import 'package:buddy/features/quiz/domain/entities/question.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final Function(String) onOptionSelected;
  final String? selectedOptionId;
  final bool isAnswering;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onOptionSelected,
    this.selectedOptionId,
    this.isAnswering = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            question.questionText,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Image.asset(
                question.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: question.options.map((option) {
              final isSelected = selectedOptionId == option.id;
              final color = _getOptionColor(option.color);
              
              return GestureDetector(
                onTap: isAnswering ? null : () => onOptionSelected(option.id),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      option.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getOptionColor(String? colorString) {
    if (colorString == null) return Colors.blue;
    
    // Parse hex color
    if (colorString.startsWith('#')) {
      return Color(int.parse('FF${colorString.substring(1)}', radix: 16));
    }
    
    // Default colors
    switch (colorString) {
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }
}
