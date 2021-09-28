import 'package:homo_habitus/model/deadline.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/icon_asset.dart';
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

  Future<double> getCompletionPercentageByDeadline(Deadline deadline) async {
    final result = await db
        .rawQuery(Queries.selectCompletionPercentageByTimeframe, ['day']);
    return result.first['completion_percentage'] as double;
  }

  Future<void> createHabit({required String name,
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
      {Columns.habit.name: name, Columns.habit.iconName: icon.name};
}

Habit habitFromMap(Map<String, Object?> map) => Habit.placeholder();

extension GoalPersistence on Goal {
  Map<String, Object?> toMap(int habitId) =>
      {
        Columns.goal.habitId: habitId,
        Columns.goal.timeframe: 'day',
        Columns.goal.targetValue: 0,
        Columns.goal.type: 'counter',
        Columns.goal.assignmentDate: generateUnixEpochTimestamp(),
      };
}