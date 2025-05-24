import 'package:flutter/material.dart';

class AnswerFeedback extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;

  const AnswerFeedback({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green[400]! : Colors.red[400]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCorrect ? Colors.green[500] : Colors.red[500],
            ),
            child: Icon(
              isCorrect ? Icons.check : Icons.close,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? "Correct!" : "Incorrect!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green[800] : Colors.red[800],
                  ),
                ),
                if (!isCorrect)
                  Text(
                    "The correct answer is: $correctAnswer",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red[800],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
