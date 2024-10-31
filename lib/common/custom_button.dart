// custom_button.dart
import 'package:flutter/material.dart';

import 'diagonal_wave_painter.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final Color topColor;
  final Color bottomColor;
  final String label;
  final double fontSize;
  final VoidCallback onPressed;

  CustomButton({
    required this.height,
    required this.width,
    required this.topColor,
    required this.bottomColor,
    required this.label,
    this.fontSize = 38,
    required this.onPressed, required String text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: bottomColor,
                  ),
                ),
                CustomPaint(
                  size: Size(double.infinity, height),
                  painter: DiagonalWavePainter(topColor),
                ),
                Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
