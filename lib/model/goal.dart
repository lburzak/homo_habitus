import 'package:homo_habitus/model/timeframe.dart';

class Goal {
  int current;
  int target;
  GoalUnit unit;
  Timeframe timeframe;

  Goal({required this.current, required this.target, required this.unit, required this.timeframe});

  double get progressPercentage => current / target;
}

enum GoalUnit {
  times,
  milliseconds
}