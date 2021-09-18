import 'package:homo_habitus/data/database_schema.dart';
import 'package:homo_habitus/data/reactive_database.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit_progress.dart';

class ProgressRepository {
  final ReactiveDatabase db;

  ProgressRepository(this.db);

  Future<void> addProgress(int habitId, int progressValue) async {
    await db
        .rawQuery(Queries.addProgressToCurrentGoal, [habitId, progressValue]);
    db.emitEvent(ProgressChangedEvent(affectedHabitId: habitId));
  }

  Stream<GoalProgress> watchProgressByHabitId(int habitId) async* {
    yield await getProgressByHabitId(habitId);
    yield* db.events
        .where((event) =>
            event is ProgressChangedEvent && event.affectedHabitId == habitId)
        .asyncMap((event) => getProgressByHabitId(habitId));
  }

  Future<GoalProgress> getProgressByHabitId(int habitId) =>
      db.rawQuery(Queries.getProgressByHabitId, [habitId]).then(
          (map) => goalProgressFromMap(map.first));
}

GoalType decodeGoalType(String serialized) {
  switch (serialized) {
    case 'timer':
      return GoalType.timer;
    case 'counter':
      return GoalType.counter;
    default:
      throw Exception("Unexpected goal type: $serialized");
  }
}

GoalProgress goalProgressFromMap(Map<String, Object?> map) {
  String type = map['type'] as String;
  int currentProgress = map['current_progress'] as int;
  int targetProgress = map['target_value'] as int;

  switch (decodeGoalType(type)) {
    case GoalType.counter:
      return CounterGoalProgress(currentProgress, targetProgress);
    case GoalType.timer:
      return TimerGoalProgress(currentProgress, targetProgress);
  }
}
