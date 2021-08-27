class Goal {
  int current;
  int target;
  GoalUnit unit;

  Goal({required this.current, required this.target, required this.unit});

  double get progressPercentage => current / target;
}

enum GoalUnit {
  times,
  milliseconds
}