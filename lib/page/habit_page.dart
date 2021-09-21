import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/bloc/habit_preview_bloc.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/habit_progress.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/repository/progress_repository.dart';
import 'package:homo_habitus/widget/habit_indicator.dart';
import 'package:homo_habitus/widget/round_button.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitPageArguments {
  final Habit habit;

  const HabitPageArguments(this.habit);
}

class HabitPage extends StatelessWidget {
  HabitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as HabitPageArguments;

    return BlocProvider(
        create: (BuildContext context) => HabitPreviewBloc(
            context.read<HabitRepository>(), context.read<ProgressRepository>(),
            initialHabit: args.habit),
        child: HabitPageBody(initialHabit: args.habit));
  }
}

class HabitPageBody extends StatelessWidget {
  HabitPageBody({
    Key? key,
    required this.initialHabit,
  }) : super(key: key);

  final Habit initialHabit;

  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: [HabitPreview(initialHabit: initialHabit), HabitLogs()]);
  }
}

class HabitPreview extends StatelessWidget {
  const HabitPreview({Key? key, required this.initialHabit}) : super(key: key);

  final Habit initialHabit;

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  child: AnimatedHabitIndicator(
                    habit: context
                        .select((HabitPreviewBloc bloc) => bloc.state.habit),
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
                            onPressed: () {
                              context
                                  .read<HabitPreviewBloc>()
                                  .add(HabitPreviewCounterIncremented());
                            },
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

class HabitLogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Material(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false, cellMargin: EdgeInsets.all(2)),
                  rowHeight: 32,
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {CalendarFormat.month: ""},
                ),
              ),
            ),
            Expanded(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  children: [
                    ListTile(
                      title: Text("22:30"),
                    ),
                    ListTile(
                      title: Text("22:30"),
                    ),
                    ListTile(
                      title: Text("22:30"),
                    ),
                    ListTile(
                      title: Text("22:30"),
                    )
                  ]),
            )
          ],
        ),
      );
}

class ProgressCounter extends StatelessWidget {
  const ProgressCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<HabitPreviewBloc, HabitPreviewState>(
          builder: (context, state) {
        var current = "";
        var target = "";

        final progress = state.habit.progress;

        if (progress is CounterGoalProgress) {
          current = progress.currentCount.toString();
          target = progress.targetCount.toString();
        } else if (progress is TimerGoalProgress) {
          current = Duration(milliseconds: progress.millisecondsPassed)
              .formatCounterDuration();
          target = Duration(milliseconds: progress.targetMilliseconds)
              .formatCounterDuration();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$current ", style: Theme.of(context).textTheme.headline4),
            Text("/ $target", style: Theme.of(context).textTheme.headline5)
          ],
        );
      });
}

extension Format on Duration {
  String formatCounterDuration() {
    return inHours > 0
        ? toString().split('.').first.padLeft(8, "0")
        : toString().substring(2, 7);
  }
}