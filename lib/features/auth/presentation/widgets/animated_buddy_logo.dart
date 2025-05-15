import 'package:flutter/material.dart';

class AnimatedBuddyLogo extends StatefulWidget {
  const AnimatedBuddyLogo({super.key});

  @override
  State<AnimatedBuddyLogo> createState() => _AnimatedBuddyLogoState();
}

class _AnimatedBuddyLogoState extends State<AnimatedBuddyLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Image.asset(
        'assets/images/buddy_logo.png',
        height: 150,
        width: 150,
      ),
    );
  }
}
