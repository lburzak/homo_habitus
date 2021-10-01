import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homo_habitus/domain/model/habit.dart';
import 'package:homo_habitus/domain/repository/habit_repository.dart';
import 'package:homo_habitus/ui/widget/material/round_indicator.dart';
import 'package:provider/provider.dart';

class HabitIndicator extends StatelessWidget {
  const HabitIndicator(
      {Key? key,
      required this.habit,
      this.progressStrokeWidth,
      this.iconSize = 42,
      this.completionRate})
      : super(key: key);

  final double iconSize;
  final double? progressStrokeWidth;
  final Habit habit;
  final double? completionRate;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "habit${habit.id}",
      child: Material(
        color: Colors.transparent,
        child: RoundIndicator(
            active: false,
            progressStrokeWidth: progressStrokeWidth ?? 3,
            progressValue: completionRate ?? habit.goal.progress.completionRate,
            body: habit.icon.asSvgPicture(context)),
      ),
    );
  }
}

class AnimatedHabitIndicator extends StatefulWidget {
  const AnimatedHabitIndicator(
      {Key? key,
      required this.habit,
      this.progressStrokeWidth,
      this.iconSize = 42})
      : super(key: key);

  final double iconSize;
  final double? progressStrokeWidth;
  final Habit habit;

  @override
  State<AnimatedHabitIndicator> createState() => _AnimatedHabitIndicatorState();
}

class _AnimatedHabitIndicatorState extends State<AnimatedHabitIndicator> {
  double oldCompletionRate = 0;
  double newCompletionRate = 0;
  StreamSubscription? subscription;

  @override
  void initState() {
    oldCompletionRate = widget.habit.goal.progress.completionRate;
    newCompletionRate = widget.habit.goal.progress.completionRate;

    subscription = context
        .read<HabitRepository>()
        .watchHabit(widget.habit.id)
        .listen((habit) {
      setState(() {
        oldCompletionRate = newCompletionRate;
        newCompletionRate = habit.goal.progress.completionRate;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 100),
        tween: Tween<double>(begin: oldCompletionRate, end: newCompletionRate),
        builder: (context, value, child) => HabitIndicator(
          habit: widget.habit,
          progressStrokeWidth: widget.progressStrokeWidth,
          iconSize: widget.iconSize,
          completionRate: value,
        ),
      );
}
