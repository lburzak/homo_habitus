import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/habit_progress.dart';
import 'package:meta/meta.dart';

part 'habit_list_state.dart';

class HabitListCubit extends Cubit<HabitListState> {
  HabitListCubit()
      : super(HabitListState(
          daySummary: TimeframeSummary(completionRate: 0.1, habits: [
            Habit(
                id: 12,
                name: "name",
                iconName: "language",
                progress: CounterGoalProgress(4, 10))
          ]),
          weekSummary: const TimeframeSummary(completionRate: 0.1, habits: []),
          monthSummary: const TimeframeSummary(completionRate: 0.1, habits: []),
        ));
}

class TimeframeSummary extends Equatable {
  final double completionRate;
  final List<Habit> habits;

  const TimeframeSummary({required this.completionRate, required this.habits});

  @override
  List<Object> get props => [completionRate, habits];
}
