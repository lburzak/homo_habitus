import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homo_habitus/domain/model/deadline.dart';
import 'package:homo_habitus/domain/model/habit.dart';
import 'package:homo_habitus/domain/repository/habit_repository.dart';

part 'habit_list_state.dart';

class HabitListCubit extends Cubit<Map<Deadline, HabitsSummary>> {
  final HabitRepository _habitRepository;

  HabitListCubit(this._habitRepository)
      : super({
          Deadline.endOfDay: const HabitsSummary.empty(),
          Deadline.endOfWeek: const HabitsSummary.empty(),
          Deadline.endOfMonth: const HabitsSummary.empty(),
        }) {
    _subscribeToData();
  }

  void _subscribeToData() {
    for (final deadline in Deadline.values) {
      _habitRepository.watchCompletionPercentageByDeadline(deadline).listen(
          (completionRate) =>
              _onCompletionRateChanged(deadline, completionRate));

      _habitRepository
          .watchHabitsByDeadline(deadline)
          .listen((habits) => _onHabitsChanged(deadline, habits));
    }
  }

  void _onHabitsChanged(Deadline deadline, List<Habit> habits) {
    emit(
        state.updated(deadline, (summary) => summary.copyWith(habits: habits)));
  }

  void _onCompletionRateChanged(Deadline deadline, double completionRate) {
    emit(state.updated(deadline,
        (summary) => summary.copyWith(completionRate: completionRate)));
  }
}

extension Copy<K, V> on Map<K, V> {
  Map<K, V> updated(K key, V Function(V value) update) =>
      Map<K, V>.from(this)..update(key, update);
}
