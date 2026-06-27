import 'package:flutter/material.dart';

class GestureScreen extends StatefulWidget {
  const GestureScreen({super.key});
  @override
  State<GestureScreen> createState() => _GestureScreenState();
}
//gesture testing....

class _GestureScreenState extends State<GestureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            print(details);
            if (details.velocity.pixelsPerSecond.dy < 0) {
              print('swipe up');
            } else {
              print('swipe down');
            }
          },
          onHorizontalDragEnd: (details) {
            print('Horizontal: $details');
            if (details.velocity.pixelsPerSecond.dx > 0) {
              print('swipe right');
            } else {
              print('swipe left');
            }
          },
          child: Container(width: 200, height: 200, color: Colors.greenAccent),
        ),
      ),
    );
  }
}
