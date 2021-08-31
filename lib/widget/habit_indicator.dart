import 'package:flutter/material.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/widget/round_indicator.dart';

class HabitIndicator extends StatelessWidget {
  const HabitIndicator({
    Key? key,
    required this.habit,
    this.progressStrokeWidth,
    this.iconSize = 42
  }) : super(key: key);

  final double iconSize;
  final double? progressStrokeWidth;
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "habit${habit.id}",
      child: Material(
        color: Colors.transparent,
        child: RoundIndicator(
            active: false,
            progressStrokeWidth: progressStrokeWidth ?? 3,
            progressValue: habit.goal.progressPercentage,
            icon: Icon(
              IconData(habit.iconCodePoint, fontFamily: "MaterialIcons"),
              size: iconSize,
            )),
      ),
    );
  }
}
