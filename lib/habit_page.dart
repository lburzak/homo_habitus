import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homo_habitus/repository/habit_repository.dart';

class HabitPage extends StatelessWidget {
  final habitRepository = HabitRepository();

  @override
  Widget build(BuildContext context) {
    final habits = habitRepository.getTodayHabits();
    const habitId = 1;
    final habit = habits[habitId];

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
      ),
    );
  }
}