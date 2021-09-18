import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/repository/progress_repository.dart';

part 'habit_preview_event.dart';
part 'habit_preview_state.dart';

class HabitPreviewBloc extends Bloc<HabitPreviewEvent, HabitPreviewState> {
  final ProgressRepository _progressRepository;

  HabitPreviewBloc(
      int habitId, HabitRepository habitRepository, this._progressRepository)
      : super(HabitPreviewInitial()) {
    habitRepository.watchHabit(habitId).listen((habit) {
      add(HabitChanged(habit));
    });
  }

  @override
  Stream<HabitPreviewState> mapEventToState(
    HabitPreviewEvent event,
  ) async* {
    final state = this.state;
    if (event is HabitPreviewCounterIncremented &&
        state is HabitPreviewLoaded) {
      await _progressRepository.addProgress(state.habit.id, 1);
    } else if (event is HabitChanged) {
      yield HabitPreviewLoaded(event.newHabit);
    }
  }
}
