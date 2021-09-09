import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/icon_asset.dart';
import 'package:homo_habitus/model/timeframe.dart';

part 'habit_creator_event.dart';
part 'habit_creator_state.dart';

class HabitCreatorBloc extends Bloc<HabitCreatorEvent, HabitCreatorState> {
  HabitCreatorBloc() : super(HabitCreatorState(
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
    } else if (event is HabitCreatorCounterDecremented) {
      if (state.targetCount < 99) {
        yield state.copyWith(
            targetCount: state.targetCount + 1
        );
      }
    } else if (event is HabitCreatorGoalChanged) {
      yield state.copyWith(
        goalType: event.goalType
      );
    } else if (event is HabitCreatorTimeframeChanged) {
      yield state.copyWith(
        timeframe: event.timeframe
      );
    } else if (event is HabitCreatorSubmitted) {
      final habit = Habit(id: 0, iconName: state.icon.name, name: state.name);

      final goal = Goal(
          timeframe: state.timeframe,
          type: state.goalType,
          targetProgress: state.targetProgress);

      print("Saving habit $habit with goal $goal");
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
