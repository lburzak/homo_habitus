import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/state/habit_list/habit_list_cubit.dart';
import 'package:homo_habitus/domain/model/deadline.dart';
import 'package:homo_habitus/domain/model/habit.dart';
import 'package:homo_habitus/domain/repository/habit_repository.dart';
import 'package:homo_habitus/ui/widget/habit_indicator.dart';
import 'package:homo_habitus/ui/widget/material/sectioned_grid.dart';

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
        child: BlocProvider(
            create: (context) =>
                HabitListCubit(context.read<HabitRepository>()),
            child: const HabitGrid()),
      ),
    );
  }

  void _openNewHabitScreen(BuildContext context) {
    Navigator.pushNamed(context, "/create_habit");
  }
}

class HabitGrid extends StatelessWidget {
  const HabitGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitListCubit, Map<Deadline, HabitsSummary>>(
      builder: (context, state) {
        return SectionedGrid(
          sections: state.entries
              .map((summary) =>
                  summary.value.toSection(_getDeadlineLabel(summary.key)))
              .toList(),
        );
      },
    );
  }

  String _getDeadlineLabel(Deadline deadline) =>
      _deadlineLabels[deadline] ?? "UNKNOWN";

  static const _deadlineLabels = {
    Deadline.endOfDay: "Today",
    Deadline.endOfWeek: "This week",
    Deadline.endOfMonth: "This month"
  };
}

extension SectionConverter on HabitsSummary {
  Section toSection(String label) => Section(
      headerBuilder: (context) =>
          TimeframeSectionHeader(label, completionPercentage: completionRate),
      childBuilder: (context, index) => HabitCell(habit: habits[index]),
      childCount: habits.length);
}

class HabitCell extends StatelessWidget {
  final Habit habit;

  const HabitCell({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          _openHabitScreen(context, habit);
        },
        child: HabitIndicator(habit: habit),
      );

  void _openHabitScreen(BuildContext context, Habit habit) {
    Navigator.pushNamed(context, "/habit",
        arguments: HabitPageArguments(habit));
  }
}

class TimeframeSectionHeader extends StatelessWidget {
  const TimeframeSectionHeader(this.name,
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
