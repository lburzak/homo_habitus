import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/widget/round_indicator.dart';

class HabitIndicator extends StatelessWidget {
  const HabitIndicator(
      {Key? key,
      required this.habit,
      this.progressStrokeWidth,
      this.iconSize = 42})
      : super(key: key);

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
            progressValue: habit.progress.completionRate,
            body: SvgPicture.asset(
              'assets/icons/${habit.iconName}.svg',
              color: Theme.of(context).iconTheme.color,
            )),
      ),
    );
  }
}
