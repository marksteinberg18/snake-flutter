import 'package:flutter/material.dart';

class GamePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint();
    bgPaint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    const int gridSize = 20;
    final double cellWidth = size.width / gridSize;
    final double cellHeight = size.height / gridSize;
    final paint = Paint();
    paint.color = Colors.grey;

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        canvas.drawRect(
          Rect.fromLTWH(
            col * cellWidth + 1,
            row * cellHeight + 1,
            cellWidth - 2,
            cellHeight - 2,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}
