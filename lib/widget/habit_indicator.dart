import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homo_habitus/model/habit_status.dart';
import 'package:homo_habitus/repository/progress_repository.dart';
import 'package:homo_habitus/widget/round_indicator.dart';
import 'package:provider/provider.dart';

class HabitIndicator extends StatefulWidget {
  const HabitIndicator(
      {Key? key,
      required this.habitStatus,
      this.progressStrokeWidth,
      this.iconSize = 42})
      : super(key: key);

  final double iconSize;
  final double? progressStrokeWidth;
  final HabitStatus habitStatus;

  @override
  State<HabitIndicator> createState() => _HabitIndicatorState();
}

class _HabitIndicatorState extends State<HabitIndicator> {
  double completionRate = 0;
  StreamSubscription? subscription;

  @override
  void initState() {
    completionRate = widget.habitStatus.completionRate;

    subscription = context
        .read<ProgressRepository>()
        .watchProgressByHabitId(widget.habitStatus.habit.id)
        .listen((progress) {
      setState(() {
        completionRate = progress.completionRate;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "habit${widget.habitStatus.habit.id}",
      child: Material(
        color: Colors.transparent,
        child: RoundIndicator(
            active: false,
            progressStrokeWidth: widget.progressStrokeWidth ?? 3,
            progressValue: completionRate,
            body: SvgPicture.asset(
              'assets/icons/${widget.habitStatus.habit.iconName}.svg',
              color: Theme.of(context).iconTheme.color,
            )),
      ),
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
