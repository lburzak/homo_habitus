import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/bloc/habit_creator_bloc.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/icon_asset.dart';
import 'package:homo_habitus/model/timeframe.dart';
import 'package:homo_habitus/widget/duration_picker.dart';
import 'package:homo_habitus/widget/option_selector.dart';
import 'package:homo_habitus/widget/round_button.dart';
import 'package:provider/provider.dart';

class CreateHabitPage extends StatelessWidget {
  CreateHabitPage({Key? key}) : super(key: key);

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
                    create: (context) => HabitCreatorBloc(),
                    child: CreateHabitView(),
                  ),
                ),
              )
            ]))
      ],
    ),
  );
}

class CreateHabitView extends StatelessWidget {
  final _goalOptionController = OptionController();
  final _timeframeOptionController = OptionController();
  final _counterEditingController = TextEditingController(text: "0");

  CreateHabitView({Key? key}) : super(key: key);

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
                              textAlign: TextAlign.center,
                              onChanged: (text) => context.read<HabitCreatorBloc>().add(HabitCreatorNameChanged(text)),
                              decoration: const InputDecoration.collapsed(
                                  hintText: "Your habit..."),
                            ),
                          ),
                        ),
                        const FractionallySizedBox(
                            widthFactor: 0.2, child: IconSelector()),
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
                          ? CounterSetupView(
                        counterEditingController:
                        _counterEditingController,
                      )
                          : TimerSetupView(
                      ))
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
                    controller: _timeframeOptionController,
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
          child: SizedBox(height: 48, child: ElevatedButton.icon(onPressed: _submit, icon: const Icon(Icons.add), label: const SizedBox.shrink())),
        )
      ],
    );
  }


  GoalType get _selectedGoalType {
    final tabIndex = _goalOptionController.selectedIndex.value;
    switch (tabIndex) {
      case 0:
        return GoalType.counter;
      case 1:
        return GoalType.timer;
      default:
        return throw Exception("Unexpected goal type index [$tabIndex]");
    }
  }

  Timeframe get _selectedTimeframe {
    final tabIndex = _timeframeOptionController.selectedIndex.value;
    switch (tabIndex) {
      case 0:
        return Timeframe.day;
      case 1:
        return Timeframe.week;
      case 2:
        return Timeframe.month;
      default:
        return throw Exception("Unexpected timeframe index [$tabIndex]");
    }
  }

  int get _selectedTargetProgress {
    final tabIndex = _goalOptionController.selectedIndex.value;
    switch (tabIndex) {
      case 0:
        return int.parse(_counterEditingController.text);
      case 1:
        return 0;
      default:
        return throw Exception("Unexpected goal type index [$tabIndex]");
    }
  }

  void _submit() {
    final habit = Habit(id: 0, iconName: "", name: "");

    final goal = Goal(
        timeframe: _selectedTimeframe,
        type: _selectedGoalType,
        targetProgress: _selectedTargetProgress);

    print("Saving habit $habit with goal $goal");
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
  final TextEditingController _counterEditingController;

  CounterSetupView({
    Key? key,
    TextEditingController? counterEditingController,
  })  : _counterEditingController =
            counterEditingController ?? TextEditingController(text: "0"),
        super(key: key);

  @override
  State<CounterSetupView> createState() => _CounterSetupViewState();
}

class _CounterSetupViewState extends State<CounterSetupView> {
  int _selectedValue = 0;

  void _increment() {
    setState(() {
      _selectedValue++;
      _updateVisibleValue();
    });
  }

  void _decrement() {
    setState(() {
      _selectedValue--;
      _updateVisibleValue();
    });
  }

  bool _canIncrement() => _selectedValue < 99;

  bool _canDecrement() => _selectedValue > 0;

  int _normalizeCounterValue(int value) {
    if (value < 0) {
      return 0;
    } else if (value > 99) {
      return 99;
    } else {
      return value;
    }
  }

  void _onValueManuallyEntered(String input) {
    if (input.isEmpty) {
      return;
    }

    final int parsedInput = int.parse(input);
    setState(() {
      _selectedValue = _normalizeCounterValue(parsedInput);
      _updateVisibleValue();
    });
  }

  void _updateVisibleValue() {
    final text = _selectedValue.toString();
    widget._counterEditingController.value = TextEditingValue(
        text: text, selection: TextSelection.collapsed(offset: text.length));
  }

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
              onPressed: _canDecrement() ? _decrement : null,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: widget._counterEditingController,
                onTap: () => widget._counterEditingController.selection =
                    TextSelection(
                        baseOffset: 0,
                        extentOffset:
                        widget._counterEditingController.text.length),
                onChanged: _onValueManuallyEntered,
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
              onPressed: _canIncrement() ? _increment : null,
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
          onTap: () => _showIconSelectionDialog(context),
          child: const FractionallySizedBox(
            heightFactor: 0.5,
            widthFactor: 0.5,
            child: Icon(Icons.extension),
          ),
        ));
  }

  void _showIconSelectionDialog(BuildContext context) {
    showModalBottomSheet(
        context: context, builder: (context) => IconSelectionGrid(onIconSelected: (icon) => print(icon),));
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

class IconAssetRepository {
  static const String _assetManifest = "AssetManifest.json";
  bool _isLoaded = false;
  List<IconAsset> _icons = List.empty();

  Future<List<IconAsset>> findAllIcons() async {
    if (!_isLoaded) {
      await _loadIconAssets();
      _isLoaded = true;
    }

    return _icons;
  }

  Future _loadIconAssets() async {
    final manifestContent = await _readManifest();
    final Map<String, dynamic> jsonManifest = json.decode(manifestContent);

    final Iterable<String> paths = jsonManifest.keys
        .where((key) => key.startsWith("assets/icons"))
        .where((key) => key.endsWith('.svg'));

    _icons = paths
        .map((path) =>
            IconAsset(name: _decodeIconNameFromPath(path), path: path))
        .toList(growable: false);
  }

  String _decodeIconNameFromPath(String path) {
    return path.split(".").first.split("/").last;
  }

  Future<String> _readManifest() async =>
      await rootBundle.loadString(_assetManifest);
}
