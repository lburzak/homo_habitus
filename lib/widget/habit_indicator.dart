import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homo_habitus/model/habit_status.dart';
import 'package:homo_habitus/widget/round_indicator.dart';

class HabitIndicator extends StatelessWidget {
  const HabitIndicator({
    Key? key,
    required this.habitStatus,
    this.progressStrokeWidth,
    this.iconSize = 42
  }) : super(key: key);

  final double iconSize;
  final double? progressStrokeWidth;
  final HabitStatus habitStatus;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "habit${habitStatus.habit.id}",
      child: Material(
        color: Colors.transparent,
        child: RoundIndicator(
            active: false,
            progressStrokeWidth: progressStrokeWidth ?? 3,
            progressValue: habitStatus.completionRate,
            body: SvgPicture.asset(
              'assets/icons/${habitStatus.habit.iconName}.svg',
              color: Theme.of(context).iconTheme.color,
            )),
      ),
    );
  }
}
