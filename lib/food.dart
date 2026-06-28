import 'dart:math';
import 'cell.dart';
import 'snake.dart';

class Food {
  final Cell foodCell;

  Food(this.foodCell);

  static Food spawn(Snake snake) {
    final occupied = snake.body.toSet();
    Cell candidate;
    do {
      candidate = Cell(Random().nextInt(20), Random().nextInt(20));
    } while (occupied.contains(candidate));
    return Food(candidate);
  }
}
