import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homo_habitus/bloc/habit_detail_state.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit_status.dart';
import 'package:homo_habitus/widget/habit_indicator.dart';
import 'package:homo_habitus/widget/round_button.dart';

class HabitPageArguments {
  final HabitStatus habitStatus;

  const HabitPageArguments(this.habitStatus);
}

class HabitPage extends StatelessWidget {  
  const HabitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as HabitPageArguments;
    final state = HabitDetailState.fromStatus(args.habitStatus);
    final habit = state.habit;

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
                child: HabitIndicator(
                  habitStatus: args.habitStatus,
                  progressStrokeWidth: 8,
                  iconSize: 120,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProgressCounter(
                    current: state.currentProgress,
                    target: state.goal.targetProgress,
                    type: state.goal.type,
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

class ProgressCounter extends StatelessWidget {
  const ProgressCounter({
    Key? key,
    required this.type,
    required this.current,
    required this.target
  }) : super(key: key);

  final GoalType type;
  final int current;
  final int target;

  @override
  Widget build(BuildContext context) {
    var currentString = current.toString();
    var targetString = target.toString();

    if (type == GoalType.timer) {
      currentString = Duration(milliseconds: current).formatCounterDuration();
      targetString = Duration(milliseconds: target).formatCounterDuration();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$currentString ", style: Theme.of(context).textTheme.headline4),
        Text("/ $targetString", style: Theme.of(context).textTheme.headline5)
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