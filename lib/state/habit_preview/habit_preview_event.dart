part of 'habit_preview_bloc.dart';

abstract class HabitPreviewEvent extends Equatable {
  const HabitPreviewEvent();
}

class HabitPreviewCounterIncremented extends HabitPreviewEvent {
  @override
  List<Object?> get props => [];
}

class HabitChanged extends HabitPreviewEvent {
  final Habit newHabit;

  const HabitChanged(this.newHabit);

  @override
  List<Object> get props => [newHabit];
}