import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/habit_progress.dart';
import 'package:homo_habitus/model/habit_status.dart';
import 'package:homo_habitus/repository/progress_repository.dart';

part 'habit_preview_event.dart';
part 'habit_preview_state.dart';

class HabitPreviewBloc extends Bloc<HabitPreviewEvent, HabitPreviewState> {
  final ProgressRepository progressRepository;

  HabitPreviewBloc(HabitStatus status, this.progressRepository)
      : super(HabitPreviewInitial.fromStatus(status)) {
    add(HabitPreviewInitialized());
  }

  @override
  Stream<HabitPreviewState> mapEventToState(
    HabitPreviewEvent event,
  ) async* {
    if (event is HabitPreviewInitialized) {
      final progress =
          await progressRepository.getProgressByHabitId(state.habit.id);
      if (progress is TimerGoalProgress) {
        yield HabitPreviewTimerStopped(
            habit: state.habit,
            millisecondsPassed: progress.millisecondsPassed,
            targetMilliseconds: progress.targetMilliseconds);
      } else if (progress is CounterGoalProgress) {
        yield HabitPreviewCounter(
            habit: state.habit,
            currentCount: progress.currentCount,
            targetCount: progress.targetCount);
      }
    } else if (event is HabitPreviewCounterIncremented) {
      await progressRepository.addProgress(state.habit.id, 1);
    }
  }
}
