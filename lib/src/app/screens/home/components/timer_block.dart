import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';

class TimerBlock extends StatelessWidget {
  const TimerBlock(
      {Key? key,
      required this.count,
      required this.suffix,
      this.backgroundColor = Colors.deepPurple,
      this.textColor = Colors.white,
      this.fontSize = 30.0})
      : super(key: key);
  final int count;
  final String suffix;
  final backgroundColor;
  final textColor;
  final fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor,
      ),
      child: AnimatedFlipCounter(
        duration: const Duration(milliseconds: 500),
        value: count,
        // pass in a value like 2014
        suffix: suffix,
        prefix: count < 10 ? '0' : '',
        textStyle: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
