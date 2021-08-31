import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/widget/round_button.dart';
import 'package:homo_habitus/widget/round_indicator.dart';

class HabitPageArguments {
  final int habitId;

  const HabitPageArguments(this.habitId);
}

class HabitPage extends StatelessWidget {
  const HabitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HabitRepository habitsRepository = RepositoryProvider.of(context);
    final habits = habitsRepository.getTodayHabits();
    final args = ModalRoute.of(context)!.settings.arguments as HabitPageArguments;
    final habitId = args.habitId;
    final habit = habits[habitId];

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Center(
                child: RoundIndicator(
                    progressValue: habit.goal.progressPercentage,
                    progressStrokeWidth: 8,
                    icon: Icon(IconData(habit.iconCodePoint,
                        fontFamily: "MaterialIcons"), size: 120)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProgressCounter(goal: habit.goal),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoundButton(
                      icon: Icons.remove,
                      onPressed: () {},
                    ),
                    SizedBox(
                        width: 64,
                        height: 64,
                        child: RoundButton(
                          icon: Icons.add,
                          onPressed: () {},
                        )),
                    RoundButton(
                      icon: Icons.exposure_plus_2,
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProgressCounter extends StatelessWidget {
  const ProgressCounter({
    Key? key,
    required this.goal,
  }) : super(key: key);

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    var current = goal.current.toString();
    var target = goal.target.toString();

    if (goal.unit == GoalUnit.milliseconds) {
      current = Duration(milliseconds: goal.current).formatCounterDuration();
      target = Duration(milliseconds: goal.target).formatCounterDuration();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$current ", style: Theme.of(context).textTheme.headline4),
        Text("/ $target", style: Theme.of(context).textTheme.headline5)
      ],
    );
  }
}

extension Format on Duration {
  String formatCounterDuration() {
    return inHours > 0
        ? toString().split('.').first.padLeft(8, "0")
        : toString().substring(2, 7);
  }
}