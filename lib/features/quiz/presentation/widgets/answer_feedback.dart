import 'package:flutter/material.dart';

class AnswerFeedback extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final VoidCallback onNext;

  const AnswerFeedback({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isCorrect ? const Color(0xFFB8F28B) : const Color(0xFFFFCDD2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  isCorrect ? 'Amazing!' : 'Ups.. that\'s wrong',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Answer : $correctAnswer',
                  style: TextStyle(
                    fontSize: 16,
                    color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect ? Colors.green : Colors.red,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Next Question',
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
}
