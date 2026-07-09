import 'dart:math';
import 'cell.dart';
import 'snake.dart';

class Food {
  final Cell cellFood;
  final int age;
  static const int maxAge = 100; //100 * 100ms = 10s until fully faded

  Food(this.cellFood, this.age);

  static Food spawn(Snake snake) {
    final occupied = snake.body.toSet();
    Cell candidate;
    do {
      candidate = Cell(Random().nextInt(20), Random().nextInt(20));
    } while (occupied.contains(candidate));

    return Food(candidate, 0);
  }

  Food ageFood() {
    return Food(cellFood, age + 1);
  }
}
