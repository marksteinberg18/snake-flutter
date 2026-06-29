import 'cell.dart';
import 'snake.dart';
import 'food.dart';

class GameState {
  final Snake snake;
  final Food food;
  final List<Cell> eatenFoodLocations;

  GameState(this.snake, this.food, this.eatenFoodLocations);

  GameState.initial()
    : snake = Snake.initial(),
      food = Food.spawn(Snake.initial()),
      eatenFoodLocations = [];

  int get score {
    return snake.body.length - 3;
  }

  GameState tick() {
    final Snake movedSnake = snake.move();
    if (movedSnake.body.first == food.foodCell) {
      //final List<Cell> newEaten = [...eatenFoodLocations, food.foodCell];
      eatenFoodLocations.add(food.foodCell);
      final Snake grownSnake = Snake(
        body: [...movedSnake.body, snake.body.last],
        direction: movedSnake.direction,
      );
      return GameState(grownSnake, Food.spawn(grownSnake), eatenFoodLocations);
    }
    return GameState(movedSnake, food, eatenFoodLocations);
  }

  GameState changeDirection(Direction dir) {
    return GameState(snake.changeDirection(dir), food, eatenFoodLocations);
  }
}
