import 'package:flutter/material.dart';
import 'package:snake_flutter/game_painter.dart';
import 'cell.dart';
import 'snake.dart';
import 'dart:async';
import 'package:snake_flutter/gesture_screen.dart';
import 'game_state.dart';
import 'food.dart';

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
  GameState gameState = GameState.initial();

  //Snake snake = Snake.initial();
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 750), (timer) {
      //print(snake.body);
      //print(snake.direction);
      setState(() {
        gameState = gameState.tick();
        //snake = snake.move();
        //print('x: ${snake.body.first.x}\t y:${snake.body.first.y}');
      });
    });
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
      body: Center(
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
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(painter: GamePainter(snake: gameState.snake)),
          ),
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
}

//TODO create a simple text box to show x,y of snake head
//TODO create a simple text box to show x,y of food
//TODO game over if snake head touches body
//TODO in game_painter.dart add food alongside snake to draw rectangle
