import 'cell.dart';
import 'snake.dart';
import 'food.dart';

class GameState {
  final Snake snake;
  final Food foodCell;
  final List<Cell> eatenFoodLocations;
  int ticksSinceMove;

  GameState(
    this.snake,
    this.foodCell,
    this.eatenFoodLocations,
    this.ticksSinceMove,
  );

  GameState.initial()
    : snake = Snake.initial(),
      foodCell = Food.spawn(Snake.initial()),
      eatenFoodLocations = [],
      ticksSinceMove = 0;

  int get score {
    return snake.body.length - 3;
  }

  GameState tick() {
    ticksSinceMove++;
    final Snake movedSnake = snake.move();
    if (movedSnake.body.first == foodCell.cellFood) {
      //final List<Cell> newEaten = [...eatenFoodLocations, food.foodCell];
      eatenFoodLocations.add(foodCell.cellFood);
      final Snake grownSnake = Snake(
        body: [...movedSnake.body, snake.body.last],
        direction: movedSnake.direction,
      );
      return GameState(
        grownSnake,
        Food.spawn(grownSnake),
        eatenFoodLocations,
        ticksSinceMove,
      );
    }
    //age food - non eaten branch, called at each tick
    Food agedFood =
        foodCell.ageFood(); //this will create a new Food object with age+1
    if (agedFood.age > Food.maxAge) {
      return GameState(
        movedSnake,
        Food.spawn(movedSnake),
        eatenFoodLocations,
        ticksSinceMove,
      );
    }
    return GameState(movedSnake, agedFood, eatenFoodLocations, ticksSinceMove);
  }

  int ageOfFood() {
    return foodCell.age;
  }

  GameState changeDirection(Direction dir) {
    return GameState(
      snake.changeDirection(dir),
      foodCell,
      eatenFoodLocations,
      ticksSinceMove,
    );
  }
}
