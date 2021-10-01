import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homo_habitus/domain/model/deadline.dart';
import 'package:homo_habitus/domain/model/goal.dart';
import 'package:homo_habitus/domain/model/icon_asset.dart';
import 'package:homo_habitus/domain/model/progress.dart';
import 'package:homo_habitus/domain/repository/habit_repository.dart';

part 'habit_creator_event.dart';

part 'habit_creator_state.dart';

class HabitCreatorBloc extends Bloc<HabitCreatorEvent, HabitCreatorState> {
  final HabitRepository habitRepository;

  HabitCreatorBloc(this.habitRepository)
      : super(HabitCreatorState(
            name: "",
            icon: IconAsset(
                name: "fact_check", path: "assets/icons/fact_check.svg"),
            deadline: Deadline.endOfDay,
            goalType: GoalType.counter,
            targetCount: 0,
            targetMinutes: 0,
            targetHours: 0,
            finished: false));

  @override
  Stream<HabitCreatorState> mapEventToState(
    HabitCreatorEvent event,
  ) async* {
    if (event is HabitCreatorNameChanged) {
      yield state.copyWith(name: event.name);
    } else if (event is HabitCreatorCounterChanged) {
      yield state.copyWith(targetCount: event.value);
    } else if (event is HabitCreatorTimerHoursChanged) {
      yield state.copyWith(targetHours: event.hours);
    } else if (event is HabitCreatorTimerMinutesChanged) {
      yield state.copyWith(targetHours: event.minutes);
    } else if (event is HabitCreatorGoalChanged) {
      yield state.copyWith(goalType: event.goalType);
    } else if (event is HabitCreatorDeadlineChanged) {
      yield state.copyWith(deadline: event.deadline);
    } else if (event is HabitCreatorIconChanged) {
      yield state.copyWith(icon: event.icon);
    } else if (event is HabitCreatorSubmitted) {
      await habitRepository.createHabit(
          name: state.name, icon: state.icon, goal: _readGoal());
      yield state.copyWith(finished: true);
    }
  }

  Goal _readGoal() => Goal(deadline: state.deadline, progress: _readProgress());

  Progress _readProgress() {
    switch (state.goalType) {
      case GoalType.counter:
        return CounterProgress.initial(state.targetProgress);
      case GoalType.timer:
        return TimerProgress.initial(state.targetProgress);
    }
  }
}

enum GoalType { counter, timer }

extension on HabitCreatorState {
  int get targetProgress {
    switch (goalType) {
      case GoalType.counter:
        return targetCount;
      case GoalType.timer:
        return Duration(hours: targetHours, minutes: targetMinutes)
            .inMilliseconds;
      default:
        return throw Exception("Unexpected goal type [$goalType]");
    }
  }
}
