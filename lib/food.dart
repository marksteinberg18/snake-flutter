import 'dart:math';
import 'cell.dart';
import 'snake.dart';
import 'package:flutter/material.dart';

enum FoodType {
  red(color: Colors.red, maxAge: 100),
  yellow(color: Colors.yellow, maxAge: 50);

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

  Food(this.cellFood, this.age, this.type);

  static Food spawn(Snake snake) {
    final occupied = snake.body.toSet();
    Cell candidate;
    do {
      candidate = Cell(_random.nextInt(20), _random.nextInt(20));
    } while (occupied.contains(candidate));

    final type = FoodType.values[Random().nextInt(FoodType.values.length)];

    return Food(candidate, 0, type);
  }

  Food ageFood() {
    return Food(cellFood, age + 1, type);
  }
}
