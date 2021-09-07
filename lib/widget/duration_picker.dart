import 'package:flutter/material.dart';
import 'package:homo_habitus/widget/wheel_picker.dart';

class DurationPicker extends StatelessWidget {
  final DurationPickerController _durationPickerController;

  DurationPicker({Key? key, DurationPickerController? durationPickerController})
      : _durationPickerController =
            durationPickerController ?? DurationPickerController(),
        super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              child: Column(
            children: [
              const PickerLabel("hours"),
              Expanded(
                child: HoursPicker(
                  onSelectedItemChanged: (number) =>
                      _durationPickerController.hours = number,
                ),
              ),
            ],
          )),
      const SizedBox(
          width: 30,
          child: PickerSeparator()),
      Expanded(
          child: Column(
            children: [
              const PickerLabel("minutes"),
              Expanded(
                child: MinutesPicker(
                  onSelectedItemChanged: (number) =>
                      _durationPickerController.minutes = number,
                ),
              ),
            ],
          )),
        ],
      );
}

class DurationPickerController extends ChangeNotifier {
  int _hours = 0;
  int _minutes = 0;

  int get hours => _hours;

  set hours(int hours) {
    _hours = hours;
    notifyListeners();
  }

  int get minutes => _minutes;

  set minutes(int minutes) {
    _minutes = minutes;
    notifyListeners();
  }
}

class MinutesPicker extends StatelessWidget {
  final void Function(int)? onSelectedItemChanged;

  const MinutesPicker({
    Key? key,
    this.onSelectedItemChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NumberPicker.builder(
      min: 0,
      max: 60,
      step: 5,
      onSelectedItemChanged: onSelectedItemChanged,
      buildChild: (number) =>
          Text(number.toString(), style: Theme.of(context).textTheme.subtitle1),
    );
  }
}

class HoursPicker extends StatelessWidget {
  final void Function(int)? onSelectedItemChanged;

  const HoursPicker({Key? key, this.onSelectedItemChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NumberPicker.builder(
      min: 0,
      max: 12,
      step: 1,
      onSelectedItemChanged: onSelectedItemChanged,
      buildChild: (number) =>
          Text(number.toString(), style: Theme.of(context).textTheme.subtitle1),
    );
  }
}

class PickerSeparator extends StatelessWidget {
  const PickerSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(":",
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: const Color(0x99ffffff)));
  }
}

class PickerLabel extends StatelessWidget {
  final String text;

  const PickerLabel(
      this.text, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: const Color(0x99ffffff)));
  }
}
