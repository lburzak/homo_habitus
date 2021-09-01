import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/habit_status.dart';

class HabitRepository {
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
}