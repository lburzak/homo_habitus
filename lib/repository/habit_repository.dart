import 'package:homo_habitus/data/database_schema.dart';
import 'package:homo_habitus/data/reactive_database.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/habit_progress.dart';
import 'package:homo_habitus/model/habit_status.dart';
import 'package:homo_habitus/model/timeframe.dart';
import 'package:homo_habitus/util/datetime.dart';

class HabitRepository {
  final ReactiveDatabase db;

  HabitRepository(this.db);

  Future<List<HabitStatus>> getTodayHabits() async {
    final rows =
        await db.rawQuery(Queries.selectHabitsStatusesByTimeframe, ['day']);
    return rows
        .map((row) => HabitStatus(
            habit: habitFromMap(row),
            completionRate: completionRateFromMap(row)))
        .toList();
  }

  Stream<List<HabitStatus>> watchTodayHabits() async* {
    yield await getTodayHabits();
    yield* db.events
        .where((event) =>
            event is HabitCreatedEvent &&
            event.createdGoal.timeframe == Timeframe.day)
        .asyncMap((event) => getTodayHabits());
  }

  Future<GoalProgress> getProgressByHabitId(int habitId) =>
      db.rawQuery(Queries.getProgressByHabitId, [habitId]).then(
          (map) => goalProgressFromMap(map.first));

  Future<void> createHabit(Habit habit, Goal initialGoal) async {
    int habitId = await db.insert(Tables.habit, habit.toMap());
    await db.insert(Tables.goal, initialGoal.toMap(habitId),
        event:
            HabitCreatedEvent(createdHabit: habit, createdGoal: initialGoal));
  }
}

extension HabitPersistence on Habit {
  Map<String, Object?> toMap() =>
      {Columns.habit.name: name, Columns.habit.iconName: iconName};
}

Habit habitFromMap(Map<String, Object?> map) => Habit(
    id: map[Columns.habit.id] as int,
    name: map[Columns.habit.name] as String,
    iconName: map[Columns.habit.iconName] as String);

double completionRateFromMap(Map<String, Object?> map) {
  int currentProgress = map['current_progress'] as int;
  int targetProgress = map['target_value'] as int;
  return currentProgress / targetProgress;
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

extension GoalPersistence on Goal {
  Map<String, Object?> toMap(int habitId) => {
        Columns.goal.habitId: habitId,
        Columns.goal.timeframe: _serializeTimeframe(),
        Columns.goal.targetValue: targetProgress,
        Columns.goal.type: _serializeType(),
        // TODO: leave it to the database
        Columns.goal.assignmentDate: generateUnixEpochTimestamp(),
      };

  String _serializeTimeframe() {
    switch (timeframe) {
      case Timeframe.day:
        return 'day';
      case Timeframe.week:
        return 'week';
      case Timeframe.month:
        return 'month';
    }
  }

  String _serializeType() {
    switch (type) {
      case GoalType.timer:
        return 'timer';
      case GoalType.counter:
        return 'counter';
    }
  }
}
