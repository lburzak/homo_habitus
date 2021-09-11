import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/habit_progress.dart';
import 'package:homo_habitus/model/habit_status.dart';
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
}