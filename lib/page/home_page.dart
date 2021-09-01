import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/model/habit_status.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/widget/habit_indicator.dart';

import 'habit_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HabitRepository habitRepository = RepositoryProvider.of(context);
    final habits = habitRepository.getTodayHabits();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              sliver: SliverFixedExtentList(delegate: SliverChildBuilderDelegate(
                      (context, index) => const SectionLabel(),
                  childCount: 1
              ), itemExtent: 30),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              _openHabitScreen(context, habits[index]);
                            },
                            child: HabitIndicator(habitStatus: habits[index]),
                          ),
                      childCount: habits.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12)),
            )
          ],
        ),
      ),
    );
  }

  void _openHabitScreen(BuildContext context, HabitStatus habitStatus) {
    Navigator.pushNamed(
        context, "/habit", arguments: HabitPageArguments(habitStatus));
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
