class Cell {
  int x;
  int y;

  Cell(this.x, this.y);

  void describe() {
    print('Cell at $x,$y');
  }

  Cell moveRight() => Cell((x + 1) % 20, y); //wraps one side to the next

  Cell moveLeft() {
    x - 1;
    if (x == 0) x = 20;
    return Cell(x, y);
  }

  Cell moveUp() {
    return Cell(x, y - 1);
  }

  Cell moveDown() {
    return Cell(x, y + 1);
  }

  @override
  bool operator ==(Object other) =>
      other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}
