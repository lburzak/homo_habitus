import 'package:flutter/material.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/timeframe.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/widget/habit_indicator.dart';
import 'package:provider/provider.dart';

import 'habit_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child:
              Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () { _openNewHabitScreen(context); }),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: CustomScrollView(
          slivers: [
            SliverSectionLabel("Today",
                completionPercentage: context
                    .read<HabitRepository>()
                    .watchCompletionPercentageByTimeframe(Timeframe.day)),
            SliverHabitGrid(
                habits: context.read<HabitRepository>().watchTodayHabits()),
            SliverSectionLabel(
              "This week",
              completionPercentage: context
                  .read<HabitRepository>()
                  .watchCompletionPercentageByTimeframe(Timeframe.week),
            ),
            SliverHabitGrid(
                habits: context.read<HabitRepository>().watchThisWeekHabits()),
            SliverSectionLabel("This month",
                completionPercentage: context
                    .read<HabitRepository>()
                    .watchCompletionPercentageByTimeframe(Timeframe.month)),
            SliverHabitGrid(
                habits: context.read<HabitRepository>().watchThisMonthHabits())
          ],
        ),
      ),
    );
  }

  void _openNewHabitScreen(BuildContext context) {
    Navigator.pushNamed(context, "/create_habit");
  }
}

class SliverHabitGrid extends StatelessWidget {
  const SliverHabitGrid({Key? key, required this.habits}) : super(key: key);

  final Stream<List<Habit>> habits;

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        sliver: StreamBuilder<List<Habit>>(
          stream: habits,
          builder: (context, snapshot) => snapshot.hasData
              ? SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              _openHabitScreen(
                                  context, snapshot.requireData[index]);
                            },
                            child: HabitIndicator(
                                habit: snapshot.requireData[index]),
                          ),
                      childCount: snapshot.requireData.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12))
              : const SliverPadding(
                  padding: EdgeInsets.all(2),
                ),
        ),
      );

  void _openHabitScreen(BuildContext context, Habit habit) {
    Navigator.pushNamed(context, "/habit",
        arguments: HabitPageArguments(habit));
  }
}

class SliverSectionLabel extends StatelessWidget {
  const SliverSectionLabel(
    this.name, {
    Key? key,
    required this.completionPercentage,
  }) : super(key: key);

  final String name;
  final Stream<double> completionPercentage;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      sliver: SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => StreamBuilder<double>(
                  stream: completionPercentage,
                  builder: (context, snapshot) => snapshot.hasData
                      ? SectionLabel(name,
                          completionPercentage: snapshot.requireData)
                      : const CircularProgressIndicator()),
              childCount: 1),
          itemExtent: 30),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.name,
      {Key? key, required, this.completionPercentage = 0})
      : super(key: key);

  final String name;
  final double completionPercentage;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: Theme.of(context).textTheme.headline6),
          Text(
            (completionPercentage * 100).toStringAsFixed(0) + "%",
            style: Theme.of(context).textTheme.subtitle1,
          )
        ],
      );
}
