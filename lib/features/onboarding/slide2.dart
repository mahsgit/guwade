import 'package:flutter/material.dart';
import 'dart:math';
import 'slide3.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: _OnboardingBackgroundPainter(),
        child: Stack(
          children: [
            // Top left star
            Positioned(top: 16, left: 16, child: _Star(size: 40)),
            // Top right star
            Positioned(top: 16, right: 16, child: _Star(size: 40)),
            // Main content
            Column(
              children: [
                const SizedBox(height: 150),
                // Central image, responsive width
                LayoutBuilder(
                  builder: (context, constraints) {
                    double imageWidth =
                        constraints.maxWidth - 32; // 16px padding each side
                    return Container(
                      width: imageWidth,
                      height: imageWidth * 0.7, // keep aspect ratio
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child:
                          Image.asset('assets/slide2.png', fit: BoxFit.cover),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  'Personalized Learning',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFBC02D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Subtitle
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Every child is unique. Guade adapts \nstories and games to fit \nyour child's mood and interests.",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                // Continue button
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: SizedBox(
                    width: 220,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFFBC02D),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const OnboardingPage3(),
                          ),
                        );
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Color(0xFFFBC02D),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFFE082); // Light yellow
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.22);
    path.lineTo(0, size.height * 0.32);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Star extends StatelessWidget {
  final double size;
  const _Star({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _StarPainter());
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path();
    final n = 5;
    final r = size.width / 2;
    final R = r;
    final r2 = r * 0.4;
    final center = Offset(r, r);
    for (int i = 0; i < 2 * n + 1; i++) {
      final isEven = i % 2 == 0;
      final radius = isEven ? R : r2;
      final angle = (i * pi / n) - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
