import 'package:flutter/material.dart';

/// クロスヘア
class CenterCrosshair extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const CenterCrosshair({
    super.key,
    this.size = 40.0,
    this.color = Colors.red,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: CustomPaint(
          size: Size(size, size),
          painter: _CrosshairPainter(color: color, strokeWidth: strokeWidth),
        ),
      ),
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _CrosshairPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}