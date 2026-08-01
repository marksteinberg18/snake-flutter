import 'cell.dart';
import 'snake.dart';
import 'food.dart';

class GameState {
  final Snake snake;
  final Food foodCell;
  final List<Cell> eatenFoodLocations;
  int ticksSinceMove;
  static const moveInterval = 0.2; //7 x 100ms = 700ms
  bool isGameOver;

  GameState(
    this.snake,
    this.foodCell,
    this.eatenFoodLocations,
    this.ticksSinceMove,
    this.isGameOver,
  );

  GameState.initial()
    : snake = Snake.initial(),
      foodCell = Food.spawn(Snake.initial()),
      eatenFoodLocations = [],
      ticksSinceMove = 0,
      isGameOver = false;

  int get score {
    return (snake.body.length - 3) * 100;
  }

  GameState tick() {
    ticksSinceMove++;
    Snake movedSnake = snake;
    if (ticksSinceMove == 2) {
      //half speed
      //time for move
      ticksSinceMove = 0;
      movedSnake = snake.move();
      //check for collision
      bool collision = movedSnake.body.skip(1).contains(movedSnake.body.first);
      if (collision == true) {
        isGameOver = true;
        return GameState(
          snake,
          foodCell,
          eatenFoodLocations,
          ticksSinceMove,
          isGameOver,
        );
      }
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
          isGameOver,
        );
      }
    }
    //age food - non eaten branch, called at each tick
    Food agedFood =
        foodCell
            .ageFood(); //this will create a new Food object with age+1, either yellow or red depending on the type
    if (agedFood.age > agedFood.type.maxAge) {
      return GameState(
        movedSnake,
        Food.spawn(movedSnake),
        eatenFoodLocations,
        ticksSinceMove,
        isGameOver,
      );
    }
    return GameState(
      movedSnake,
      agedFood,
      eatenFoodLocations,
      ticksSinceMove,
      isGameOver,
    );
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
      isGameOver,
    );
  }
}
