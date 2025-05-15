import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/story_quiz.dart';

class StoryQuizWidget extends StatefulWidget {
  final StoryQuiz quiz;
  final Function(bool) onAnswered;

  const StoryQuizWidget({
    super.key,
    required this.quiz,
    required this.onAnswered,
  });

  @override
  State<StoryQuizWidget> createState() => _StoryQuizWidgetState();
}

class _StoryQuizWidgetState extends State<StoryQuizWidget> {
  int? _selectedOptionIndex;
  bool _hasSubmitted = false;
  bool _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Text(
            widget.quiz.question,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // Options
          ...List.generate(
            widget.quiz.options.length,
            (index) => GestureDetector(
              onTap: _hasSubmitted ? null : () {
                setState(() {
                  _selectedOptionIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: _getOptionColor(index),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: _getOptionBorderColor(index),
                    width: 2.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Option letter
                    Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getOptionBorderColor(index),
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index), // A, B, C, D...
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getOptionBorderColor(index),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12.0),
                    
                    // Option text
                    Expanded(
                      child: Text(
                        widget.quiz.options[index],
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    
                    // Correct/incorrect icon
                    if (_hasSubmitted && index == widget.quiz.correctOptionIndex)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    else if (_hasSubmitted && index == _selectedOptionIndex && index != widget.quiz.correctOptionIndex)
                      const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // Submit button
          if (!_hasSubmitted)
            ElevatedButton(
              onPressed: _selectedOptionIndex != null
                  ? () {
                      setState(() {
                        _hasSubmitted = true;
                        _isCorrect = _selectedOptionIndex == widget.quiz.correctOptionIndex;
                      });
                      widget.onAnswered(_isCorrect);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Submit Answer',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Result message
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: _isCorrect
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: _isCorrect ? Colors.green : Colors.red,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isCorrect ? Icons.check_circle : Icons.cancel,
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          _isCorrect
                              ? 'Correct! Great job!'
                              : 'Oops! That\'s not right.',
                          style: TextStyle(
                            color: _isCorrect ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12.0),
                
                // Explanation
                Text(
                  'Explanation: ${widget.quiz.explanation}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                
                const SizedBox(height: 16.0),
                
                // Continue button
                ElevatedButton(
                  onPressed: () {
                    // Reset the quiz state
                    setState(() {
                      _selectedOptionIndex = null;
                      _hasSubmitted = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  Color _getOptionColor(int index) {
    if (!_hasSubmitted) {
      return _selectedOptionIndex == index
          ? AppColors.secondary.withOpacity(0.2)
          : Colors.white;
    } else {
      if (index == widget.quiz.correctOptionIndex) {
        return Colors.green.withOpacity(0.1);
      } else if (index == _selectedOptionIndex) {
        return Colors.red.withOpacity(0.1);
      } else {
        return Colors.white;
      }
    }
  }
  
  Color _getOptionBorderColor(int index) {
    if (!_hasSubmitted) {
      return _selectedOptionIndex == index
          ? AppColors.secondary
          : Colors.grey.shade300;
    } else {
      if (index == widget.quiz.correctOptionIndex) {
        return Colors.green;
      } else if (index == _selectedOptionIndex) {
        return Colors.red;
      } else {
        return Colors.grey.shade300;
      }
    }
  }
}
