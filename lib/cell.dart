class Cell {
  int x;
  int y;
  static const int gridSize = 20;

  Cell(this.x, this.y);

  @override
  String toString() => 'Cell at $x,$y';

  void describe() {
    print('Cell at $x,$y');
  }

  Cell moveRight() => Cell((x + 1) % gridSize, y); //wraps one side to the next
  Cell moveLeft() => Cell((x - 1 + gridSize) % gridSize, y);
  Cell moveUp() => Cell(x, (y - 1 + gridSize) % gridSize);
  Cell moveDown() => Cell(x, (y + 1) % gridSize);

  @override
  bool operator ==(Object other) =>
      other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}
