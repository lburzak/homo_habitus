import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:homo_habitus/widget/duration_picker.dart';
import 'package:homo_habitus/widget/option_selector.dart';
import 'package:homo_habitus/widget/round_button.dart';

class CreateHabitPage extends StatelessWidget {
  CreateHabitPage({Key? key}) : super(key: key);

  final _goalOptionController = OptionController(initialIndex: 1);
  final _habitNameController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text('New habit'),
              pinned: true,
              elevation: 4,
              collapsedHeight: 80,
              toolbarHeight: 80,
            ),
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: CreateHabitView(
                      habitNameController: _habitNameController,
                      goalOptionController: _goalOptionController),
                ),
              )
            ]))
          ],
        ),
      );
}

class CreateHabitView extends StatelessWidget {
  const CreateHabitView({
    Key? key,
    required TextEditingController habitNameController,
    required OptionController goalOptionController,
  })  : _habitNameController = habitNameController,
        _goalOptionController = goalOptionController,
        super(key: key);

  final TextEditingController _habitNameController;
  final OptionController _goalOptionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormSection("Habit",
            child: SizedBox(
              height: 60,
              child: Material(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.onBackground,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    fit: StackFit.passthrough,
                      children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          controller: _habitNameController,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration.collapsed(
                              hintText: "Your habit..."),
                        ),
                      ),
                    ),
                    const FractionallySizedBox(widthFactor: 0.2, child: IconSelector()),
                  ])),
            )),
        FormSection("Goal",
            child: Material(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.onBackground,
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: GoalTypeSelector(
                        goalOptionController: _goalOptionController),
                  ),
                  ValueListenableBuilder<int>(
                      valueListenable: _goalOptionController.selectedIndex,
                      builder: (context, value, child) => value == 0
                          ? const CounterSetupView()
                          : const TimerSetupView())
                ],
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: FormSection("Repetition",
              child: Material(
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  height: 48,
                  child: OptionSelector(
                    options: [
                      Option("Daily"),
                      Option("Weekly"),
                      Option("Monthly")
                    ],
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
          child: SizedBox(height: 48, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const SizedBox.shrink())),
        )
      ],
    );
  }
}

class GoalTypeSelector extends StatelessWidget {
  const GoalTypeSelector({
    Key? key,
    required OptionController goalOptionController,
  })  : _goalOptionController = goalOptionController,
        super(key: key);

  final OptionController _goalOptionController;

  @override
  Widget build(BuildContext context) {
    return OptionSelector(
      controller: _goalOptionController,
      options: [
        Option("Counter",
            leading: const Icon(
              Icons.tag,
              size: 16,
            )),
        Option("Timer",
            leading: const Icon(
              Icons.timer,
              size: 16,
            ))
      ],
    );
  }
}

class TimerSetupView extends StatelessWidget {
  const TimerSetupView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(height: 120, child: DurationPicker()),
    );
  }
}

class CounterSetupView extends StatelessWidget {
  const CounterSetupView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundButton(
              icon: Icons.remove,
              onPressed: () {},
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(text: "0"),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  suffixText: "times",
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundButton(
              icon: Icons.add,
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }
}

class FormSection extends StatelessWidget {
  const FormSection(this.label, {Key? key, required this.child})
      : super(key: key);

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: child,
          ),
        ],
      ),
    );
  }
}

class IconSelector extends StatelessWidget {
  const IconSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: const FractionallySizedBox(
            heightFactor: 0.5,
            widthFactor: 0.5,
            child: Icon(Icons.extension),
          ),
        ));
  }
}
