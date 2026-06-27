import 'cell.dart';
import 'dart:math';

enum Direction { up, down, left, right }

class Snake {
  late List<Cell> body;
  late Direction direction;

  Snake({required this.body, required this.direction});

  Snake.initial() {
    //: body = [Cell(10, 10), Cell(9, 10), Cell(8, 10)],
    direction = Direction.values[Random().nextInt(4)];
    final Cell head = Cell(10, 10);
    body = switch (direction) {
      Direction.right => [head, Cell(9, 10), Cell(8, 10)],
      Direction.left => [Cell(9, 10), Cell(10, 10), Cell(11, 10)],
      Direction.up => [head, Cell(10, 11), Cell(10, 12)],
      Direction.down => [head, Cell(10, 9), Cell(10, 8)],
    };

    //direction = Direction.values[Random().nextInt(4)];
  }

  Snake changeDirection(Direction newDir) {
    const opposite = {
      Direction.up: Direction.down,
      Direction.down: Direction.up,
      Direction.left: Direction.right,
      Direction.right: Direction.left,
    };
    if (newDir == opposite[direction]) return this;
    return Snake(body: body, direction: newDir);
  }

  Snake move() {
    Cell newHead = switch (direction) {
      Direction.up => body.first.moveUp(),
      Direction.right => body.first.moveRight(),
      Direction.down => body.first.moveDown(),
      Direction.left => body.first.moveLeft(),
    };

    //Cell newHead = body.first;
    List<Cell> newBody = [];
    newBody.add(newHead);
    for (Cell cell in body) {
      newBody.add(cell);
    }
    newBody.removeLast();
    return Snake(body: newBody, direction: direction);
  }
}
