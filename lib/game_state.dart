import 'cell.dart';
import 'snake.dart';
import 'food.dart';
import 'dart:math';

class GameState {
  final Snake snake;
  final Food foodCell;
  final List<Cell> eatenFoodLocations;
  int ticksSinceMove;
  static const moveInterval = 0.2; //7 x 100ms = 700ms
  bool isGameOver;
  final List<Cell> poisonLocations;
  static final Random _random = Random();
  int lives;

  GameState(
    this.snake,
    this.foodCell,
    this.eatenFoodLocations,
    this.ticksSinceMove,
    this.isGameOver,
    this.poisonLocations,
    this.lives,
  );

  GameState.initial()
    : snake = Snake.initial(),
      foodCell = Food.spawn(Snake.initial()),
      eatenFoodLocations = [],
      ticksSinceMove = 0,
      isGameOver = false,
      poisonLocations = [],
      lives = 3;

  int get score {
    return (snake.body.length - 3) * 100 * (1 + poisonLocations.length);
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
      bool selfCollision = movedSnake.body
          .skip(1)
          .contains(movedSnake.body.first);
      if (selfCollision == true) {
        isGameOver = true;
        return GameState(
          snake,
          foodCell,
          eatenFoodLocations,
          ticksSinceMove,
          isGameOver,
          poisonLocations,
          lives,
        );
      }

      //landed on poison
      bool poisonCollision = poisonLocations.contains(movedSnake.body.first);
      if (poisonCollision == true) {
        lives = lives - 1;
        if (lives == 0) {
          isGameOver = true;
          return GameState(
            snake,
            foodCell,
            eatenFoodLocations,
            ticksSinceMove,
            isGameOver,
            poisonLocations,
            lives,
          );
        } else {
          //reset snake
          Snake resetSnake = Snake.initial();
          //check if poison or food is overlying the snake's initial position
          bool poisonOverlying = resetSnake.body.any(
            (cell) => poisonLocations.contains(cell),
          );
          List<Cell> poisonsClashingWithSnake =
              poisonLocations
                  .where(((poison) => resetSnake.body.contains(poison)))
                  .toList();

          if (poisonsClashingWithSnake.isNotEmpty) {
            int numberPoisonsAffected = poisonsClashingWithSnake.length;
            //need to delete these entries first
            for (Cell poison in poisonsClashingWithSnake) {
              poisonLocations.remove(poison);
            }
            //respawn
            for (int i = 0; i < numberPoisonsAffected; i++) {
              _spawnPoison();
            }
          }
          return GameState(
            resetSnake,
            foodCell,
            eatenFoodLocations,
            ticksSinceMove,
            isGameOver,
            poisonLocations,
            lives,
          );
        }
      }

      //eaten food
      if (movedSnake.body.first == foodCell.cellFood) {
        //final List<Cell> newEaten = [...eatenFoodLocations, food.foodCell];
        eatenFoodLocations.add(foodCell.cellFood);
        final Snake grownSnake = Snake(
          body: [...movedSnake.body, snake.body.last],
          direction: movedSnake.direction,
        );
        //if third food then spawn poison
        if (eatenFoodLocations.length % 3 == 0 &&
            eatenFoodLocations.isNotEmpty) {
          poisonLocations.add(_spawnPoison()); //add new
        }
        return GameState(
          grownSnake,
          Food.spawn(grownSnake),
          eatenFoodLocations,
          ticksSinceMove,
          isGameOver,
          poisonLocations,
          lives,
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
        poisonLocations,
        lives,
      );
    }
    return GameState(
      movedSnake,
      agedFood,
      eatenFoodLocations,
      ticksSinceMove,
      isGameOver,
      poisonLocations,
      lives,
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
      poisonLocations,
      lives,
    );
  }

  Cell _spawnPoison() {
    //work out where we cannot go
    final occupied = snake.body.toSet(); //snake
    occupied.add(foodCell.cellFood); //current food cell
    occupied.addAll(poisonLocations);
    //now... where can we go?
    Cell newPoison;
    do {
      newPoison = Cell(_random.nextInt(20), _random.nextInt(20));
    } while (occupied.contains(newPoison));
    return newPoison;
  }
}
