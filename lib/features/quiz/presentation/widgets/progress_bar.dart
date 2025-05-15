import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;
        final isCurrent = index == currentStep - 1;
        
        return Container(
          width: 24,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
