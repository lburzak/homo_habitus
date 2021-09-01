import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/timeframe.dart';

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
          unit: GoalUnit.milliseconds,
          timeframe: Timeframe.day
        )
      ),
      Habit(
        id: 1,
        name: "Say hi",
        iconName: 'people',
        goal: Goal(
          current: 4,
          target: 4,
          unit: GoalUnit.times,
          timeframe: Timeframe.day
        )
      )
    ];
  }
}