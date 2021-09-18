part of 'habit_preview_bloc.dart';

abstract class HabitPreviewState extends Equatable {}

class HabitPreviewInitial extends HabitPreviewState {
  @override
  List<Object> get props => [];
}

class HabitPreviewLoaded extends HabitPreviewState {
  final Habit habit;

  HabitPreviewLoaded(this.habit);

  @override
  List<Object?> get props => [habit];
}
