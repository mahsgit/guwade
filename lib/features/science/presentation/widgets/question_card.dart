import 'package:buddy/features/science/domain/entities/question.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final Function(int)? onAnswerSelected;
  final int? selectedAnswerIndex;
  final int? correctAnswerIndex;

  const QuestionCard({
    super.key,
    required this.question,
    this.onAnswerSelected,
    this.selectedAnswerIndex,
    this.correctAnswerIndex,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedAnswerIndex;
  }

  @override
  void didUpdateWidget(QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedAnswerIndex != oldWidget.selectedAnswerIndex) {
      _selectedIndex = widget.selectedAnswerIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            widget.question.options.length,
            (index) => _buildOptionItem(index),
          ),
          if (widget.onAnswerSelected != null && _selectedIndex != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedIndex != null) {
                      widget.onAnswerSelected!(_selectedIndex!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.brown[800],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Submit Answer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(int index) {
    final option = widget.question.options[index];
    final isSelected = _selectedIndex == index;
    final isCorrect = widget.correctAnswerIndex == index;
    final isIncorrect = widget.correctAnswerIndex != null && 
                        _selectedIndex == index && 
                        !isCorrect;
    
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Widget? trailingIcon;
    
    if (widget.correctAnswerIndex != null) {
      // Answer has been submitted
      if (isCorrect) {
        backgroundColor = Colors.green[100]!;
        borderColor = Colors.green[500]!;
        trailingIcon = Icon(Icons.check_circle, color: Colors.green[700]);
      } else if (isIncorrect) {
        backgroundColor = Colors.red[100]!;
        borderColor = Colors.red[500]!;
        trailingIcon = Icon(Icons.cancel, color: Colors.red[700]);
      }
    } else if (isSelected) {
      backgroundColor = Colors.amber[100]!;
      borderColor = Colors.amber[500]!;
    }

    return GestureDetector(
      onTap: widget.onAnswerSelected == null ? null : () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.amber[700]! : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? Colors.amber[700] : Colors.white,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );
  }
}
