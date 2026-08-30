import 'cell.dart';
import 'snake.dart';
import 'food.dart';
import 'dart:math';

enum GameEvent { none, ateFood, atePoison, poisonGenerated, gameOver }

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
  final GameEvent lastEvent;
  static const gridSize = Cell.gridSize;
  int pauseTicksRemaining;

  GameState(
    this.snake,
    this.foodCell,
    this.eatenFoodLocations,
    this.ticksSinceMove,
    this.isGameOver,
    this.poisonLocations,
    this.lives,
    this.lastEvent,
    this.pauseTicksRemaining,
  );

  GameState.initial()
    : snake = Snake.initial(),
      eatenFoodLocations = [],
      ticksSinceMove = 0,
      isGameOver = false,
      poisonLocations = [],
      foodCell = Food.spawn(Snake.initial(), []),
      lives = 3,
      lastEvent = GameEvent.none,
      pauseTicksRemaining = 0;

  int get score {
    return (snake.body.length - 3) * 100 * (1 + poisonLocations.length);
  }

  GameState tick() {
    if (pauseTicksRemaining > 0) {
      pauseTicksRemaining--; //we're in a pause state - life lost, count down
      if (pauseTicksRemaining == 0) {
        //freeze JUST ended now
        Snake resetSnake = Snake.initial();

        //check if poison or food is overlying the snake's initial position
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
          //respawn THAT number of deleted poisons elsewhere on board
          for (int i = 0; i < numberPoisonsAffected; i++) {
            poisonLocations.add(_spawnPoison(resetSnake));
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
          GameEvent.atePoison,
          pauseTicksRemaining,
        );
      }
      return GameState(
        snake,
        foodCell,
        eatenFoodLocations,
        ticksSinceMove,
        isGameOver,
        poisonLocations,
        lives,
        GameEvent.none,
        pauseTicksRemaining,
      );
    }
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
          GameEvent.gameOver,
          pauseTicksRemaining,
        );
      }

      //landed on poison
      bool poisonCollision = poisonLocations.contains(movedSnake.body.first);
      if (poisonCollision == true) {
        lives = lives - 1;
        if (lives == 0) {
          isGameOver = true;
          return GameState(
            movedSnake,
            foodCell,
            eatenFoodLocations,
            ticksSinceMove,
            isGameOver,
            poisonLocations,
            lives,
            GameEvent
                .gameOver, //TODO gameOver should be divided to gameOverSelfCollision and gameOverLifesLost
            pauseTicksRemaining,
          );
        }
        pauseTicksRemaining =
            15; //eaten poison - need to freeze, pause for 100ms x 15 = 1.5s

        return GameState(
          movedSnake,
          foodCell,
          eatenFoodLocations,
          ticksSinceMove,
          isGameOver,
          poisonLocations,
          lives,
          GameEvent.atePoison,
          pauseTicksRemaining,
        );
      }

      //eaten food

      if (movedSnake.body.first == foodCell.cellFood) {
        bool poisonGenerated = false;
        eatenFoodLocations.add(foodCell.cellFood);
        final Snake grownSnake = Snake(
          body: [
            ...movedSnake.body,
            snake.body.last,
          ], //how does this line work?
          direction: movedSnake.direction,
        );
        //if third food then spawn poison
        if (eatenFoodLocations.length % 3 == 0 &&
            eatenFoodLocations.isNotEmpty) {
          poisonLocations.add(_spawnPoison(grownSnake));
          poisonGenerated = true; //add new
        }
        return GameState(
          grownSnake,
          Food.spawn(grownSnake, poisonLocations),
          eatenFoodLocations,
          ticksSinceMove,
          isGameOver,
          poisonLocations,
          lives,
          poisonGenerated
              ? GameEvent.poisonGenerated
              : GameEvent.ateFood, //what happens with this line?
          pauseTicksRemaining,
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
        Food.spawn(movedSnake, poisonLocations),
        eatenFoodLocations,
        ticksSinceMove,
        isGameOver,
        poisonLocations,
        lives,
        GameEvent.none,
        pauseTicksRemaining,
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
      GameEvent.none,
      pauseTicksRemaining,
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
      GameEvent.none,
      pauseTicksRemaining,
    );
  }

  Cell _spawnPoison(Snake snake) {
    //work out where we cannot go
    final occupied = snake.body.toSet(); //snake
    occupied.add(foodCell.cellFood); //current food cell
    occupied.addAll(poisonLocations); //can't go where we're already at
    //exclude the row or column that we're travelling against:
    Cell head = snake.body.first; //e.g. [3,5]
    switch (snake.direction) {
      case Direction.up || Direction.down:
        //add whole column to occupied, already occupied will not be added to as a set
        for (int y = 0; y <= gridSize; y++) {
          occupied.add(Cell(head.x, y));
        }
      case Direction.left || Direction.right:
        //add whole row to occupied, already occupied will not be added to as a set
        for (int x = 0; x <= gridSize; x++) {
          occupied.add(Cell(x, head.y));
        }
    }
    //now... where can we go?
    Cell newPoison;
    do {
      newPoison = Cell(_random.nextInt(gridSize), _random.nextInt(gridSize));
    } while (occupied.contains(newPoison));
    return newPoison;
  }
}
