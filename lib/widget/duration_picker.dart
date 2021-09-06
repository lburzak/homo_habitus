import 'package:flutter/material.dart';
import 'package:homo_habitus/widget/wheel_picker.dart';

class DurationPicker extends StatelessWidget {
  const DurationPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
          child: Column(
            children: const [
              PickerLabel("hours"),
              Expanded(
                child: HoursPicker(),
              ),
            ],
          )),
      const SizedBox(
          width: 30,
          child: PickerSeparator()),
      Expanded(
          child: Column(
            children: const [
              PickerLabel("minutes"),
              Expanded(
                child: MinutesPicker(),
              ),
            ],
          )),
    ],
  );
}

class MinutesPicker extends StatelessWidget {
  const MinutesPicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NumberPicker.builder(
      min: 0,
      max: 60,
      step: 5,
      buildChild: (number) => Text(number.toString(),
          style: Theme.of(context).textTheme.subtitle1),
    );
  }
}

class HoursPicker extends StatelessWidget {
  const HoursPicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NumberPicker.builder(
      min: 0,
      max: 12,
      step: 1,
      buildChild: (number) => Text(number.toString(),
          style: Theme.of(context).textTheme.subtitle1),
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
