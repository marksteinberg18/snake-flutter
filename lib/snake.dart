import 'cell.dart';

enum Direction { up, down, left, right }

class Snake {
  List<Cell> body;
  Direction direction;

  Snake({required this.body, required this.direction});

  Snake.initial()
    : body = [Cell(10, 10), Cell(9, 10), Cell(8, 10)],
      direction = Direction.right;

  Snake move() {
    Cell newHead = body.first.moveRight();
    List<Cell> newBody = [];
    newBody.add(newHead);
    for (Cell cell in body) {
      newBody.add(cell);
    }
    newBody.removeLast();
    return Snake(body: newBody, direction: direction);
  }
}
