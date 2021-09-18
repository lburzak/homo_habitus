part of 'habit_preview_bloc.dart';

class HabitPreviewState extends Equatable {
  final Habit habit;

  const HabitPreviewState(this.habit);

  @override
  List<Object> get props => [habit];
}
