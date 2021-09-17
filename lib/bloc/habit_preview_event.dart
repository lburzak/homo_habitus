part of 'habit_preview_bloc.dart';

abstract class HabitPreviewEvent extends Equatable {
  const HabitPreviewEvent();
}

class HabitPreviewInitialized extends HabitPreviewEvent {
  @override
  List<Object?> get props => [];
}

class HabitPreviewCounterIncremented extends HabitPreviewEvent {
  @override
  List<Object?> get props => [];
}
