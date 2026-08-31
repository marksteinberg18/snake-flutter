import 'dart:math';
import 'cell.dart';
import 'snake.dart';
import 'package:flutter/material.dart';

enum FoodType {
  red(color: Colors.red, maxAge: 100),
  yellow(color: Colors.yellow, maxAge: 50);
  //TODO remove colors red and yellow and introduce a random maxage between 50 and 100

  final Color color;
  final int maxAge;

  const FoodType({required this.color, required this.maxAge});
}

class Food {
  final Cell cellFood;
  final int age;
  static const int maxAge = 100; //100 * 100ms = 10s until fully faded
  final FoodType type;
  static final Random _random = Random();
  static const gridSize = Cell.gridSize;

  Food(this.cellFood, this.age, this.type);

  static Food spawn(Snake snake, List<Cell> poisonLocations) {
    final occupied = snake.body.toSet();
    occupied.addAll(poisonLocations);
    Cell head = snake.body.first; //e.g. [3,5]
    switch (snake.direction) {
      case Direction.up || Direction.down:
        //add whole column to occupied, already occupied will not be added to as a set
        for (int y = 0; y < gridSize; y++) {
          occupied.add(Cell(head.x, y));
        }
      case Direction.left || Direction.right:
        //add whole row to occupied, already occupied will not be added to as a set
        for (int x = 0; x < gridSize; x++) {
          occupied.add(Cell(x, head.y));
        }
    }
    Cell candidate;
    do {
      candidate = Cell(_random.nextInt(gridSize), _random.nextInt(gridSize));
    } while (occupied.contains(candidate));
    final type = FoodType.values[_random.nextInt(FoodType.values.length)];
    return Food(candidate, 0, type);
  }

  Food ageFood() {
    return Food(cellFood, age + 1, type);
  }
}
