import 'package:flutter/material.dart';
import 'snake.dart';
import 'food.dart';
import 'cell.dart';

class GamePainter extends CustomPainter {
  final Snake snake;
  final Food food;
  final List<Cell> poisonLocations;

  GamePainter({
    required this.snake,
    required this.food,
    required this.poisonLocations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //print('Foodcell: ${food.cellFood.x},${food.cellFood.y}');
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
    snakePaint.color = Colors.green;
    final headPaint = Paint();
    headPaint.color = Colors.greenAccent;

    for (final cell in snake.body) {
      canvas.drawRect(
        Rect.fromLTWH(
          cell.x * cellWidth + 1,
          cell.y * cellHeight + 1,
          cellWidth,
          cellHeight,
        ),
        cell == snake.body.first ? headPaint : snakePaint,
      );
    }
    //to print food red rectangle here....
    double alpha = ((food.type.maxAge - food.age) / (food.type.maxAge - 1))
        .clamp(0.0, 1.0);
    final foodPaint = Paint();
    foodPaint.color = food.type.color.withValues(alpha: alpha);
    //foodPaint.color = Colors.red.withValues(alpha: alpha);
    final int foodX = food.cellFood.x;
    final int foodY = food.cellFood.y;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          foodX * cellWidth + 1,
          foodY * cellHeight + 1,
          cellWidth,
          cellHeight,
        ),
        Radius.circular(4),
      ),
      foodPaint,
    );
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}
