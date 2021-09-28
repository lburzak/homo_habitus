import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/bloc/habit_creator_bloc.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/timeframe.dart';
import 'package:homo_habitus/page/select_icon_dialog.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/widget/duration_picker.dart';
import 'package:homo_habitus/widget/form_section.dart';
import 'package:homo_habitus/widget/number_picker.dart';
import 'package:homo_habitus/widget/option_selector.dart';
import 'package:provider/provider.dart';

class CreateHabitPage extends StatelessWidget {
  const CreateHabitPage({Key? key}) : super(key: key);

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
                  child: BlocProvider<HabitCreatorBloc>(
                    create: (context) =>
                        HabitCreatorBloc(context.read<HabitRepository>()),
                    child: BlocListener<HabitCreatorBloc, HabitCreatorState>(
                        listener: (context, state) {
                          if (state.finished) {
                            Navigator.pop(context);
                          }
                        },
                        child: const CreateHabitView()),
                  ),
                ),
              )
            ]))
          ],
        ),
      );
}

class CreateHabitView extends StatelessWidget {
  const CreateHabitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        HabitSection(),
        GoalSection(),
        Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: RepetitionSection(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 24.0, bottom: 12.0),
          child: SubmitButton(),
        )
      ],
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 48,
        child: ElevatedButton.icon(
            onPressed: () =>
                context.read<HabitCreatorBloc>().add(HabitCreatorSubmitted()),
            icon: const Icon(Icons.add),
            label: const SizedBox.shrink()));
  }
}

class RepetitionSection extends StatelessWidget {
  const RepetitionSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormSection("Repetition",
        child: SizedBox(
          height: 48,
          child: OptionSelector<Timeframe>(
            onChange: (timeframe) => context
                .read<HabitCreatorBloc>()
                .add(HabitCreatorTimeframeChanged(timeframe)),
            options: [
              Option(Timeframe.day, label: "Daily"),
              Option(Timeframe.week, label: "Weekly"),
              Option(Timeframe.month, label: "Monthly")
            ],
          ),
        ));
  }
}

class GoalSection extends StatelessWidget {
  const GoalSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormSection("Goal",
        child: Column(
          children: [
            const SizedBox(
              height: 48,
              child: GoalTypeSelector(),
            ),
            BlocBuilder<HabitCreatorBloc, HabitCreatorState>(
                builder: (context, state) {
                  switch (state.goalType) {
                    case GoalType.counter:
                      return NumberPicker(
                        onChanged: (number) => context
                            .read<HabitCreatorBloc>()
                            .add(HabitCreatorCounterChanged(number)),
                        maxDigits: 2,
                      );
                    case GoalType.timer:
                      return const TimerSetupView();
                  }
                },
                buildWhen: (previous, current) =>
                    previous.goalType != current.goalType)
          ],
        ));
  }
}

class HabitSection extends StatelessWidget {
  const HabitSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormSection("Habit",
        child: SizedBox(
          height: 60,
          child: Stack(
              alignment: Alignment.centerLeft,
              fit: StackFit.passthrough,
              children: const [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: HabitNameField(),
                  ),
                ),
                FractionallySizedBox(widthFactor: 0.2, child: IconPreview()),
              ]),
        ));
  }
}

class HabitNameField extends StatelessWidget {
  const HabitNameField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      onChanged: (text) =>
          context.read<HabitCreatorBloc>().add(HabitCreatorNameChanged(text)),
      decoration: const InputDecoration.collapsed(hintText: "Your habit..."),
    );
  }
}

class GoalTypeSelector extends StatelessWidget {
  const GoalTypeSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OptionSelector<GoalType>(
      onChange: (GoalType goalType) => context
          .read<HabitCreatorBloc>()
          .add(HabitCreatorGoalChanged(goalType)),
      options: [
        Option<GoalType>(GoalType.counter,
            label: "Counter",
            leading: const Icon(
              Icons.tag,
              size: 16,
            )),
        Option<GoalType>(GoalType.timer,
            label: "Timer",
            leading: const Icon(
              Icons.timer,
              size: 16,
            ))
      ],
    );
  }
}

class TimerSetupView extends StatelessWidget {
  const TimerSetupView(
      {Key? key, DurationPickerController? durationPickerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 120,
        child: DurationPicker(
            onHoursChanged: (hours) => context
                .read<HabitCreatorBloc>()
                .add(HabitCreatorTimerHoursChanged(hours)),
            onMinutesChanged: (minutes) => context
                .read<HabitCreatorBloc>()
                .add(HabitCreatorTimerMinutesChanged(minutes))),
      ),
    );
  }
}

class IconPreview extends StatelessWidget {
  const IconPreview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showIconSelectionDialog(context),
          child: BlocBuilder<HabitCreatorBloc, HabitCreatorState>(
            builder: (context, state) => FractionallySizedBox(
              heightFactor: 0.5,
              widthFactor: 0.5,
              child: state.icon.asSvgPicture(context),
            ),
          ),
        ));
  }

  void _showIconSelectionDialog(BuildContext context) {
    SelectIconDialog.show(
        context,
        (icon) => context
            .read<HabitCreatorBloc>()
            .add(HabitCreatorIconChanged(icon)));
  }
}
