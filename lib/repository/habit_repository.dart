import 'package:homo_habitus/data/database_schema.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/habit_progress.dart';
import 'package:homo_habitus/model/habit_status.dart';
import 'package:homo_habitus/model/timeframe.dart';
import 'package:homo_habitus/util/datetime.dart';
import 'package:sqflite/sqflite.dart';

class HabitRepository {
  final Database db;

  HabitRepository(this.db);

  List<HabitStatus> getTodayHabits() {
    return [
      HabitStatus(
          habit: Habit(id: 0, name: "Workout", iconName: 'language'),
          completionRate: 0.7),
      HabitStatus(
          habit: Habit(
            id: 1,
            name: "Say hi",
            iconName: 'people',
          ),
          completionRate: 0.3)
    ];
  }

  GoalProgress getProgressByHabitId(int habitId) {
    return TimerGoalProgress(3000, 60000);
  }
  
  Future<void> createHabit(Habit habit, Goal initialGoal) async {
    db.transaction((txn) async {
      int habitId = await db.insert(Tables.habit, habit.toMap());
      await db.insert(Tables.goal, initialGoal.toMap(habitId));
    });
  }
}

extension HabitPersistence on Habit {
  Map<String, Object?> toMap() => {
    Columns.habit.name: name,
    Columns.habit.iconName: iconName
  };
}

extension GoalPersistence on Goal {
  Map<String, Object?> toMap(int habitId) => {
    Columns.goal.habitId: habitId,
    Columns.goal.timeframe: _serializeTimeframe(),
    Columns.goal.targetValue: targetProgress,
    Columns.goal.type: _serializeType(),
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
