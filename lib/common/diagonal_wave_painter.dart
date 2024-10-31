// diagonal_wave_painter.dart
import 'package:flutter/material.dart';

class DiagonalWavePainter extends CustomPainter {
  final Color color;

  DiagonalWavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path();

    // Start from the bottom-left corner
    path.moveTo(0, size.height * 1);

    // First cubic Bezier curve (smooth from left to center)
    path.cubicTo(
      size.width * 0.7, size.height * 0.95, // First control point
      size.width * 0.4, size.height * 0.1, // Second control point
      size.width * 1, size.height * 0, // End point
    );

    // Close the path by drawing to the bottom-right corner
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw the path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
