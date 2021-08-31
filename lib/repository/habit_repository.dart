import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';

class HabitRepository {
  List<Habit> getTodayHabits() {
    return [
      Habit(
        id: 0,
        name: "Workout",
        iconName: 'language',
        goal: Goal(
          current: 30 * 1000,
          target: 10 * 60 * 1000,
          unit: GoalUnit.milliseconds
        )
      ),
      Habit(
        id: 1,
        name: "Say hi",
        iconName: 'people',
        goal: Goal(
          current: 3,
          target: 4,
          unit: GoalUnit.times
        )
      )
    ];
  }
}