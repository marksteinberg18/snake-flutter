import 'package:flutter/material.dart';
import 'snake.dart';

class GamePainter extends CustomPainter {
  final Snake snake;
  GamePainter({required this.snake});

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

    //TODO make grey alternate grey shade
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        paint.color =
            (row + col) % 2 == 0 ? Colors.grey[700]! : Colors.grey[800]!;
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
    final snakePaint = Paint();
    snakePaint.color = Colors.greenAccent;
    for (final cell in snake.body) {
      canvas.drawRect(
        Rect.fromLTWH(
          cell.x * cellWidth + 1,
          cell.y * cellHeight + 1,
          cellWidth,
          cellHeight,
        ),
        snakePaint,
      );
    }
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}
