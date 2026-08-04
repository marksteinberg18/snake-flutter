import 'package:flutter/material.dart';
import 'package:snake_flutter/game_painter.dart';
import 'cell.dart';
import 'snake.dart';
import 'dart:async';
import 'game_state.dart';
import 'food.dart';
import 'package:flutter/services.dart';
import 'sound_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: GameScreen(), //const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Timer _timer;
  late SoundManager _soundManager;
  String aboveInformationLine1 = 'Score: 0';
  String aboveInformationLine2 = 'Game Over';
  String belowInformationLine1 = 'Tap Grid';
  String belowInformationLine2 = 'To Start Again';
  late GameState gameState;

  //Snake snake = Snake.initial();
  @override
  void initState() {
    _startGame();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    aboveInformationLine1,
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'ScoreLineFont',
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    gameState.isGameOver ? aboveInformationLine2 : '',
                    style: TextStyle(
                      color: Colors.pink,
                      fontFamily: 'ScoreLineFont',
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    print(details);
                    if (details.velocity.pixelsPerSecond.dy < 0) {
                      changeDirection(Direction.up);
                      print('swipe up');
                    } else {
                      changeDirection(Direction.down);
                      print('swipe down');
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    print('Horizontal: $details');
                    if (details.velocity.pixelsPerSecond.dx > 0) {
                      changeDirection(Direction.right);

                      print('swipe right');
                    } else {
                      changeDirection(Direction.left);
                      print('swipe left');
                    }
                  },
                  onTap: () {
                    if (gameState.isGameOver) {
                      _startGame();
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CustomPaint(
                      painter: GamePainter(
                        snake: gameState.snake,
                        food: gameState.foodCell,
                        poisonLocations: gameState.poisonLocations,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    gameState.isGameOver ? belowInformationLine1 : '',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontFamily: 'ScoreLineFont',
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    gameState.isGameOver ? belowInformationLine2 : '',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontFamily: 'ScoreLineFont',
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeDirection(Direction newDir) {
    setState(() {
      gameState = gameState.changeDirection(newDir);
      //snake = snake.changeDirection(newDir);
    });
  }

  void _startGame() {
    _soundManager = SoundManager();
    _soundManager.init();
    setState(() {
      gameState = GameState.initial();
    });
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      //print(snake.body);
      //print(snake.direction);
      setState(() {
        print('Poison food location: ${gameState.poisonLocations.first}');
        final int oldEatenCount = gameState.eatenFoodLocations.length;
        gameState = gameState.tick();
        aboveInformationLine1 = 'Score: ${gameState.score}';
        final int newEatenCount = gameState.eatenFoodLocations.length;
        //print('Age of food: ${gameState.ageOfFood()}');
        if (gameState.isGameOver == true) {
          _timer.cancel();
        }

        if (newEatenCount > oldEatenCount) {
          //snake has eaten some food!
          print('eaten!!');
          HapticFeedback.vibrate();

          _soundManager.playSound();
        }
        //snake = snake.move();
        //print('x: ${snake.body.first.x}\t y:${snake.body.first.y}');
      });
    });
  }
}

//TODO create a simple text box to show x,y of snake head
//TODO create a simple text box to show x,y of food
//TODO game over if snake head touches body
//TODO in game_painter.dart add food alongside snake to draw rectangle
