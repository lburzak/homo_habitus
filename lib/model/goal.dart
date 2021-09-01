import 'package:homo_habitus/model/timeframe.dart';

class Goal {
  int targetProgress;
  GoalType type;
  Timeframe timeframe;

  Goal({required this.targetProgress, required this.type, required this.timeframe});
}

enum GoalType {
  counter,
  timer
}