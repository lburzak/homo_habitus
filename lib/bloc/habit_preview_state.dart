part of 'habit_preview_bloc.dart';

abstract class HabitPreviewState extends Equatable {
  final Habit habit;
  final double completionRate;

  const HabitPreviewState(this.habit, this.completionRate);

  @override
  List<Object?> get props => [habit, completionRate];
}

class HabitPreviewInitial extends HabitPreviewState {
  HabitPreviewInitial(Habit habit)
      : super(habit, habit.progress.completionRate);
}

class HabitPreviewCounter extends HabitPreviewState {
  final int currentCount;
  final int targetCount;

  const HabitPreviewCounter(
      {required habit, required this.currentCount, required this.targetCount})
      : super(habit, currentCount / targetCount);

  @override
  List<Object?> get props => [habit, completionRate, targetCount, currentCount];
}

abstract class HabitPreviewTimer extends HabitPreviewState {
  final int millisecondsPassed;
  final int targetMilliseconds;

  const HabitPreviewTimer(Habit habit, double completionRate,
      this.millisecondsPassed, this.targetMilliseconds)
      : super(habit, millisecondsPassed / targetMilliseconds);

  @override
  List<Object?> get props =>
      [habit, completionRate, millisecondsPassed, targetMilliseconds];
}

class HabitPreviewTimerStopped extends HabitPreviewTimer {
  const HabitPreviewTimerStopped(
      {required Habit habit,
      required int millisecondsPassed,
      required int targetMilliseconds})
      : super(habit, millisecondsPassed / targetMilliseconds,
            millisecondsPassed, targetMilliseconds);
}

class HabitPreviewTimerStarted extends HabitPreviewTimer {
  const HabitPreviewTimerStarted(
      {required Habit habit,
      required int millisecondsPassed,
      required int targetMilliseconds})
      : super(habit, millisecondsPassed / targetMilliseconds,
            millisecondsPassed, targetMilliseconds);
}
