part of 'habit_list_cubit.dart';

class HabitListState extends Equatable {
  final Map<Deadline, HabitsSummary> summaries;

  const HabitListState(this.summaries);

  @override
  List<Object?> get props => [summaries];
}

class HabitsSummary extends Equatable {
  final double completionRate;
  final List<Habit> habits;

  const HabitsSummary({required this.completionRate, required this.habits});

  const HabitsSummary.empty()
      : completionRate = 0,
        habits = const [];

  @override
  List<Object> get props => [completionRate, habits];

  HabitsSummary copyWith({
    double? completionRate,
    List<Habit>? habits,
  }) {
    return HabitsSummary(
      completionRate: completionRate ?? this.completionRate,
      habits: habits ?? this.habits,
    );
  }
}
