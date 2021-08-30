import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/round_indicator.dart';

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
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Center(
                child: RoundIndicator(
                    height: 180,
                    width: 180,
                    progressValue: habit.goal.progressPercentage,
                    progressStrokeWidth: 8,
                    icon: IconData(habit.iconCodePoint,
                        fontFamily: "MaterialIcons")),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 36),
                child: Text(
                  "${(habit.goal.progressPercentage * 100).toStringAsFixed(0)}%",
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}