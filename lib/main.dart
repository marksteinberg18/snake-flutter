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
              child: _displayCards([
                _cardGenerator(
                  icon: '✅',
                  label: 'SCORE',
                  valueAsString: gameState.score.toString(),
                  color: Colors.green,
                ),
                _cardGenerator(
                  icon: '🐍',
                  label: 'LIVES',
                  valueAsString: '❤️' * gameState.lives,
                  color: Colors.red,
                ),
                _cardGenerator(
                  icon: '🏆',
                  label: 'BEST',
                  valueAsString: '0',
                  color: Colors.red,
                ),
              ]),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onPanEnd: (details) {
                    final double vx = details.velocity.pixelsPerSecond.dx;
                    final double vy = details.velocity.pixelsPerSecond.dy;
                    if (vx.abs() > vy.abs()) {
                      changeDirection(
                        vx > 0 ? Direction.right : Direction.left,
                      );
                    } else {
                      changeDirection(vy > 0 ? Direction.down : Direction.up);
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
                  _displayCards([
                    _cardGenerator(
                      icon: '🥫',
                      label: 'FOOD EATEN',
                      valueAsString:
                          gameState.eatenFoodLocations.length.toString(),
                      color: Colors.greenAccent,
                    ),
                    _cardGenerator(
                      icon: '☠️',
                      label: 'POISONS',
                      valueAsString:
                          gameState.poisonLocations.length.toString(),
                      color: Colors.deepPurple,
                    ),
                  ]),
                  // Text(
                  //   gameState.isGameOver ? belowInformationLine1 : '',
                  //   style: TextStyle(
                  //     color: Colors.yellow,
                  //     fontFamily: 'ScoreLineFont',
                  //     fontSize: 30,
                  //   ),
                  // ),
                  // Text(
                  //   gameState.isGameOver ? belowInformationLine2 : '',
                  //   style: TextStyle(
                  //     color: Colors.yellow,
                  //     fontFamily: 'ScoreLineFont',
                  //     fontSize: 30,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayCards(List<Widget> cards) {
    final List<Widget> rowChildren = [];
    for (int i = 0; i < cards.length; i++) {
      if (i > 0) {
        rowChildren.add(const SizedBox(width: 16));
      }
      rowChildren.add(Expanded(child: cards[i]));
    }
    return Row(children: rowChildren);
  }

  Widget _cardGenerator({
    required String icon,
    required String label,
    required String valueAsString,
    required Color color,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              icon,
              style: const TextStyle(fontSize: 28, color: Colors.red),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$valueAsString',
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
        final int oldEatenCount = gameState.eatenFoodLocations.length;
        gameState = gameState.tick();
        aboveInformationLine1 = 'Score: ${gameState.score}';
        final int newEatenCount = gameState.eatenFoodLocations.length;
        //print('Age of food: ${gameState.ageOfFood()}');
        if (gameState.isGameOver == true) {
          _timer.cancel();
        }

        //import gameEvent and playsound

        if (newEatenCount > oldEatenCount) {
          //snake has eaten some food!
          print('eaten!!');
          HapticFeedback.vibrate();

          //_soundManager.playSoundSuccess();
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
