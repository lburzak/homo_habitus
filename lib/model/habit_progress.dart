abstract class GoalProgress {}

class TimerGoalProgress extends GoalProgress {
  final int millisecondsPassed;
  final int targetMilliseconds;

  TimerGoalProgress(this.millisecondsPassed, this.targetMilliseconds);
}

class CounterGoalProgress extends GoalProgress {
  final int currentCount;
  final int targetCount;

  CounterGoalProgress(this.currentCount, this.targetCount);
}