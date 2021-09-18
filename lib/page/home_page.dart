import 'package:flutter/material.dart';
import 'package:homo_habitus/model/habit.dart';
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              sliver: SliverFixedExtentList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => const SectionLabel(),
                      childCount: 1),
                  itemExtent: 30),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              sliver: StreamBuilder<List<Habit>>(
                stream: context.read<HabitRepository>().watchTodayHabits(),
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12))
                    : const SliverPadding(padding: EdgeInsets.all(2),),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openHabitScreen(BuildContext context, Habit habit) {
    Navigator.pushNamed(context, "/habit",
        arguments: HabitPageArguments(habit));
  }

  void _openNewHabitScreen(BuildContext context) {
    Navigator.pushNamed(context, "/create_habit");
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text("Today", style: Theme.of(context).textTheme.headline6),
      Text(
        "47%",
        style: Theme.of(context).textTheme.subtitle1,
      )
    ],
  );
}
