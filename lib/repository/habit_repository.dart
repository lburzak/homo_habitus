import 'package:homo_habitus/data/database_schema.dart';
import 'package:homo_habitus/data/habit_dao.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/habit_progress.dart';
import 'package:homo_habitus/model/habit_status.dart';
import 'package:homo_habitus/model/timeframe.dart';
import 'package:homo_habitus/util/datetime.dart';
import 'package:sqflite/sqflite.dart';

class HabitRepository {
  final HabitDao habitDao;
  final Database db;

  HabitRepository(this.db) : habitDao = HabitDao(db);

  Stream<List<HabitStatus>> getTodayHabits() async* {
    final rows =
        await db.rawQuery(Queries.selectHabitsStatusesByTimeframe, ['day']);
    final statuses = rows
        .map((map) => HabitStatus(
            habit: habitFromMap(map),
            completionRate: completionRateFromMap(map)))
        .toList();
    yield statuses;
  }

  GoalProgress getProgressByHabitId(int habitId) {
    return TimerGoalProgress(3000, 60000);
  }

  Future<void> createHabit(Habit habit, Goal initialGoal) async {
    int habitId = await habitDao.insert(habit);
    await db.insert(Tables.goal, initialGoal.toMap(habitId));
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
