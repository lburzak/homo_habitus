import 'package:homo_habitus/data/database_schema.dart';
import 'package:homo_habitus/data/reactive_database.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/icon_asset.dart';
import 'package:homo_habitus/model/timeframe.dart';
import 'package:homo_habitus/repository/progress_repository.dart';
import 'package:homo_habitus/util/datetime.dart';

class HabitRepository {
  final ReactiveDatabase db;

  HabitRepository(this.db);

  Future<List<Habit>> getTodayHabits() async {
    final rows =
        await db.rawQuery(Queries.selectHabitsStatusesByTimeframe, ['day']);
    return rows.map((row) => habitFromMap(row)).toList();
  }

  Stream<List<Habit>> watchTodayHabits() async* {
    yield await getTodayHabits();
    yield* db.events
        .where((event) =>
            event is HabitCreatedEvent &&
            event.createdGoal.timeframe == Timeframe.day)
        .asyncMap((event) => getTodayHabits());
  }

  Future<void> createHabit(
      {required String name,
      required IconAsset icon,
      required Goal goal}) async {
    int habitId = await db.insert(Tables.habit,
        {Columns.habit.name: name, Columns.habit.iconName: icon.name});

    await db.insert(Tables.goal, goal.toMap(habitId),
        event: HabitCreatedEvent(createdGoal: goal));
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
