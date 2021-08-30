import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${habit.goal.current} ",
                          style: Theme.of(context).textTheme.headline4),
                      Text("/ ${habit.goal.target}",
                          style: Theme.of(context).textTheme.headline5)
                    ],
                  ),
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