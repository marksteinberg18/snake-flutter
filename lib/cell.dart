class Cell {
  int x;
  int y;

  Cell(this.x, this.y);

  void describe() {
    print('Cell at $x,$y');
  }

  Cell moveRight() => Cell((x + 1) % 20, y); //wraps one side to the next
  Cell moveLeft() => Cell((x - 1 + 20) % 20, y);
  Cell moveUp() => Cell(x, (y - 1 + 20) % 20);
  Cell moveDown() => Cell(x, (y + 1) % 20);

  @override
  bool operator ==(Object other) =>
      other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}
