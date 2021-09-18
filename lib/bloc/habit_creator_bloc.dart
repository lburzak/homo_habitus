import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/icon_asset.dart';
import 'package:homo_habitus/model/timeframe.dart';
import 'package:homo_habitus/repository/habit_repository.dart';

part 'habit_creator_event.dart';
part 'habit_creator_state.dart';

class HabitCreatorBloc extends Bloc<HabitCreatorEvent, HabitCreatorState> {
  final HabitRepository habitRepository;

  HabitCreatorBloc(this.habitRepository) : super(HabitCreatorState(
    name: "",
    icon: IconAsset(
      name: "fact_check",
      path: "assets/icons/fact_check.svg"
    ),
    timeframe: Timeframe.day,
    goalType: GoalType.counter,
    targetCount: 0,
    targetMinutes: 0,
    targetHours: 0,
    finished: false
  ));

  @override
  Stream<HabitCreatorState> mapEventToState(
    HabitCreatorEvent event,
  ) async* {
    if (event is HabitCreatorNameChanged) {
      yield state.copyWith(
        name: event.name
      );
    } else if (event is HabitCreatorCounterChanged) {
      yield state.copyWith(
        targetCount: _normalizeCounterValue(event.value)
      );
    } else if (event is HabitCreatorCounterDecremented) {
      if (state.targetCount > 0) {
        yield state.copyWith(
          targetCount: state.targetCount - 1
        );
      }
    } else if (event is HabitCreatorCounterIncremented) {
      if (state.targetCount < 99) {
        yield state.copyWith(targetCount: state.targetCount + 1);
      }
    } else if (event is HabitCreatorTimerHoursChanged) {
      yield state.copyWith(targetHours: event.hours);
    } else if (event is HabitCreatorTimerMinutesChanged) {
      yield state.copyWith(targetHours: event.minutes);
    } else if (event is HabitCreatorGoalChanged) {
      yield state.copyWith(goalType: event.goalType);
    } else if (event is HabitCreatorTimeframeChanged) {
      yield state.copyWith(timeframe: event.timeframe);
    } else if (event is HabitCreatorIconChanged) {
      yield state.copyWith(icon: event.icon);
    } else if (event is HabitCreatorSubmitted) {
      final goal = Goal(
          timeframe: state.timeframe,
          type: state.goalType,
          targetProgress: state.targetProgress);

      await habitRepository.createHabit(
          name: state.name, icon: state.icon, goal: goal);
      yield state.copyWith(finished: true);
    }
  }

  int _normalizeCounterValue(int value) {
    if (value < 0) {
      return 0;
    } else if (value > 99) {
      return 99;
    } else {
      return value;
    }
  }

  @override
  void onEvent(HabitCreatorEvent event) {
    print(event);
  }
}

extension on HabitCreatorState {
  int get targetProgress {
    switch (goalType) {
      case GoalType.counter:
        return targetCount;
      case GoalType.timer:
        return Duration(hours: targetHours, minutes: targetMinutes).inMilliseconds;
      default:
        return throw Exception("Unexpected goal type [$goalType]");
    }
  }
}
