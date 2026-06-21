import 'cell.dart';

enum Direction { up, down, left, right }

class Snake {
  List<Cell> body;
  Direction direction;

  Snake({required this.body, required this.direction});

  Snake.initial()
    : body = [Cell(10, 10), Cell(9, 10), Cell(8, 10)],
      direction = Direction.right;

  // {
  //   Cell head = Cell(10, 10);
  //   Cell body1 = Cell(9, 10);
  //   Cell body2 = Cell(8, 10);
  //   List<Cell> body;
  //   body = [head, body1, body2];
  //   Direction direction = Direction.right;
  //   return Snake(body: body, direction: direction);
  // }
}
