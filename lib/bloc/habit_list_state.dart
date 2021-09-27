part of 'habit_list_cubit.dart';

@immutable
class HabitListState extends Equatable {
  final TimeframeSummary daySummary;
  final TimeframeSummary weekSummary;
  final TimeframeSummary monthSummary;

  const HabitListState(
      {required this.daySummary,
      required this.weekSummary,
      required this.monthSummary});

  @override
  List<Object> get props => [daySummary, weekSummary, monthSummary];
}
