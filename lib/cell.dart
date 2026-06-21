class Cell {
  int x;
  int y;

  Cell(this.x, this.y);

  void describe() {
    print('Cell at $x,$y');
  }

  Cell moveRight() {
    return Cell(x + 1, y);
  }

  Cell moveLeft() {
    return Cell(x - 1, y);
  }

  Cell moveUp() {
    return Cell(x, y - 1);
  }

  Cell moveDown() {
    return Cell(x, y + 1);
  }
}
