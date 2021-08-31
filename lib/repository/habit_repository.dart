import 'package:flutter/material.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';

class HabitRepository {
  List<Habit> getTodayHabits() {
    return [
      Habit(
        id: 0,
        name: "Workout",
        iconCodePoint: Icons.fitness_center.codePoint,
        goal: Goal(
          current: 30 * 1000,
          target: 10 * 60 * 1000,
          unit: GoalUnit.milliseconds
        )
      ),
      Habit(
        id: 1,
        name: "Say hi",
        iconCodePoint: Icons.people.codePoint,
        goal: Goal(
          current: 3,
          target: 4,
          unit: GoalUnit.times
        )
      )
    ];
  }
}