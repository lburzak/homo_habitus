import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/bloc/habit_creator_bloc.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/icon_asset.dart';
import 'package:homo_habitus/model/timeframe.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/repository/icon_asset_repository.dart';
import 'package:homo_habitus/widget/duration_picker.dart';
import 'package:homo_habitus/widget/option_selector.dart';
import 'package:homo_habitus/widget/round_button.dart';
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
                      return const CounterSetupView();
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
                FractionallySizedBox(widthFactor: 0.2, child: IconSelector()),
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

class GoalTypeSelector extends StatefulWidget {
  const GoalTypeSelector({
    Key? key,
  }) : super(key: key);

  @override
  State<GoalTypeSelector> createState() => _GoalTypeSelectorState();
}

class _GoalTypeSelectorState extends State<GoalTypeSelector> {
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

class CounterSetupView extends StatefulWidget {
  const CounterSetupView({Key? key}) : super(key: key);

  @override
  State<CounterSetupView> createState() => _CounterSetupViewState();
}

class _CounterSetupViewState extends State<CounterSetupView> {
  late final TextEditingController _counterEditingController =
      TextEditingController(
          text: context.read<HabitCreatorBloc>().state.targetCount.toString());

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
              onPressed: () => context
                  .read<HabitCreatorBloc>()
                  .add(HabitCreatorCounterDecremented()),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              BlocListener<HabitCreatorBloc, HabitCreatorState>(
                listener: (context, state) =>
                    _updateVisibleValue(state.targetCount),
                child: TextField(
                  controller: _counterEditingController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onTap: _selectAll,
                  onChanged: (text) => _onValueManuallyEntered(context, text),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    suffixText: "times",
                  ),
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
              onPressed: () => context
                  .read<HabitCreatorBloc>()
                  .add(HabitCreatorCounterIncremented()),
            ),
          ),
        )
      ],
    );
  }

  void _selectAll() {
    _counterEditingController.selection = TextSelection(
        baseOffset: 0, extentOffset: _counterEditingController.text.length);
  }

  void _onValueManuallyEntered(BuildContext context, String input) {
    if (input.isEmpty) {
      return;
    }

    final int parsedInput = int.parse(input);

    context
        .read<HabitCreatorBloc>()
        .add(HabitCreatorCounterChanged(parsedInput));
  }

  void _updateVisibleValue(int newValue) {
    final text = newValue.toString();
    _counterEditingController.value = TextEditingValue(
        text: text, selection: TextSelection.collapsed(offset: text.length));
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
            child: Material(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.onBackground,
                child: child),
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

  void _showIconSelectionDialog(BuildContext pageContext) {
    showModalBottomSheet(
        context: pageContext,
        builder: (context) => IconSelectionGrid(
              onIconSelected: (icon) => pageContext
                  .read<HabitCreatorBloc>()
                  .add(HabitCreatorIconChanged(icon)),
            ));
  }
}

class IconSelectionGrid extends StatelessWidget {
  final void Function(IconAsset)? onIconSelected;

  const IconSelectionGrid({Key? key, this.onIconSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<IconAssetRepository>(
      create: (context) => IconAssetRepository(),
      builder: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Choose icon",
                style: Theme.of(context).textTheme.subtitle1),
          ),
          Expanded(
            child: FutureBuilder<List<IconAsset>>(
              future: context.read<IconAssetRepository>().findAllIcons(),
              builder: (context, snapshot) => snapshot.hasData
                  ? GridView.builder(
                      itemCount: snapshot.data!.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (context, index) =>
                          IconSelectionTile(snapshot.data![index], onTap: () {
                        onIconSelected!(snapshot.data![index]);
                        Navigator.pop(context);
                      }),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class IconSelectionTile extends StatelessWidget {
  final IconAsset iconAsset;
  final void Function()? onTap;

  const IconSelectionTile(this.iconAsset, {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: 0.6,
        heightFactor: 0.6,
        child: iconAsset.asSvgPicture(context),
      ),
    );
  }
}
