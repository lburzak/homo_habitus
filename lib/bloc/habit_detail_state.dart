import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/habit_status.dart';
import 'package:homo_habitus/model/timeframe.dart';

class HabitDetailState {
  final Habit habit;
  final Goal goal;
  final int currentProgress;
  final double completionRate;

  HabitDetailState(
      {required this.habit,
      required this.goal,
      required this.currentProgress,
      required this.completionRate});

  HabitDetailState.fromStatus(HabitStatus status)
      : habit = status.habit,
        goal = Goal(
            targetProgress: 10,
            type: GoalType.counter,
            timeframe: Timeframe.day),
        completionRate = status.completionRate,
        currentProgress = 5;
}
