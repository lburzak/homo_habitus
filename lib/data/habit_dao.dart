import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/habit_progress.dart';
import 'package:homo_habitus/model/icon_asset.dart';
import 'package:homo_habitus/model/timeframe.dart';
import 'package:homo_habitus/util/datetime.dart';
import 'package:sqflite/sqflite.dart';

import 'database_schema.dart';

class HabitDao {
  HabitDao(this.db);

  final Database db;

  Future<List<Habit>> getTodayHabits() async {
    final rows =
        await db.rawQuery(Queries.selectHabitsStatusesByTimeframe, ['day']);
    return rows.map((row) => habitFromMap(row)).toList();
  }

  Future<List<Habit>> getThisWeekHabits() async {
    final rows =
        await db.rawQuery(Queries.selectHabitsStatusesByTimeframe, ['week']);
    return rows.map((row) => habitFromMap(row)).toList();
  }

  Future<List<Habit>> getThisMonthHabits() async {
    final rows =
        await db.rawQuery(Queries.selectHabitsStatusesByTimeframe, ['month']);
    return rows.map((row) => habitFromMap(row)).toList();
  }

  Future<Habit> getHabitById(int id) async {
    final map = await db.rawQuery(Queries.selectHabitById, [id]);
    return habitFromMap(map.first);
  }

  Future<void> createHabit(
      {required String name,
      required IconAsset icon,
      required Goal goal}) async {
    await db.transaction((txn) async {
      final habitId = await txn.insert(Tables.habit,
          {Columns.habit.name: name, Columns.habit.iconName: icon.name});
      await txn.insert(Tables.goal, goal.toMap(habitId));
    });
  }
}

extension HabitPersistence on Habit {
  Map<String, Object?> toMap() =>
      {Columns.habit.name: name, Columns.habit.iconName: iconName};
}

Habit habitFromMap(Map<String, Object?> map) => Habit(
    id: map[Columns.habit.id] as int,
    name: map[Columns.habit.name] as String,
    iconName: map[Columns.habit.iconName] as String,
    progress: goalProgressFromMap(map));

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