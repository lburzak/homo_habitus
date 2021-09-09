part of 'habit_creator_bloc.dart';

abstract class HabitCreatorEvent extends Equatable {
  const HabitCreatorEvent();
}

class HabitCreatorNameChanged extends HabitCreatorEvent {
  final String name;

  const HabitCreatorNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class HabitCreatorCounterChanged extends HabitCreatorEvent {
  final int value;

  const HabitCreatorCounterChanged(this.value);

  @override
  List<Object> get props => [value];
}

class HabitCreatorCounterIncremented extends HabitCreatorEvent {
  @override
  List<Object> get props => [];
}

class HabitCreatorCounterDecremented extends HabitCreatorEvent {
  @override
  List<Object> get props => [];
}

class HabitCreatorTimerHoursChanged extends HabitCreatorEvent {
  final int hours;

  const HabitCreatorTimerHoursChanged(this.hours);

  @override
  List<Object> get props => [hours];
}

class HabitCreatorTimerMinutesChanged extends HabitCreatorEvent {
  final int minutes;

  const HabitCreatorTimerMinutesChanged(this.minutes);

  @override
  List<Object> get props => [minutes];
}

class HabitCreatorGoalChanged extends HabitCreatorEvent {
  final GoalType goalType;

  const HabitCreatorGoalChanged(this.goalType);

  @override
  List<Object> get props => [goalType];
}

class HabitCreatorTimeframeChanged extends HabitCreatorEvent {
  final Timeframe timeframe;

  const HabitCreatorTimeframeChanged(this.timeframe);

  @override
  List<Object> get props => [timeframe];
}

class HabitCreatorSubmitted extends HabitCreatorEvent {
  @override
  List<Object> get props => [];
}
