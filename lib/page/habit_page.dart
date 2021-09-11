import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/bloc/habit_preview_bloc.dart';
import 'package:homo_habitus/model/habit_status.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
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
    final args =
        ModalRoute.of(context)!.settings.arguments as HabitPageArguments;

    return BlocProvider(
        create: (BuildContext context) => HabitPreviewBloc(args.habitStatus, context.read<HabitRepository>()),
        child: const HabitPreview());
  }
}

class HabitPreview extends StatelessWidget {
  const HabitPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            context.select((HabitPreviewBloc bloc) => bloc.state.habit.name)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Center(
                child: HabitIndicator(
                  habitStatus: context.select((HabitPreviewBloc bloc) =>
                      HabitStatus(
                          completionRate: bloc.state.completionRate,
                          habit: bloc.state.habit)),
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ProgressCounter(),
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
  const ProgressCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.select((HabitPreviewBloc bloc) => bloc.state);

    var current = "";
    var target = "";

    if (state is HabitPreviewCounter) {
      current = state.currentCount.toString();
      target = state.targetCount.toString();
    } else if (state is HabitPreviewTimer) {
      current = Duration(milliseconds: state.millisecondsPassed)
          .formatCounterDuration();
      target = Duration(milliseconds: state.targetMilliseconds)
          .formatCounterDuration();
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