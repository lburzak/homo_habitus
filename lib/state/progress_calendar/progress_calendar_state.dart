part of 'progress_calendar_cubit.dart';

abstract class ProgressCalendarState extends Equatable {
  const ProgressCalendarState();
}

class ProgressCalendarInitial extends ProgressCalendarState {
  @override
  List<Object> get props => [];
}

class ProgressCalendarLoading extends ProgressCalendarState {
  @override
  List<Object> get props => [];
}

class ProgressCalendarLoaded extends ProgressCalendarState {
  final List<int> fulfilledDays;

  const ProgressCalendarLoaded(this.fulfilledDays);

  bool checkDayFulfilled(DateTime dateTime) =>
      fulfilledDays.contains(dateTime.day);

  @override
  List<Object> get props => [fulfilledDays];
}
