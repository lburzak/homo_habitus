import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homo_habitus/ui/widget/material/round_button.dart';

class NumberPicker extends StatefulWidget {
  NumberPicker(
      {Key? key,
      required this.maxDigits,
      this.onChanged,
      this.initialValue = 0})
      : maxValue = _maxValueOfDigits(maxDigits),
        super(key: key);

  final int maxDigits;
  final int initialValue;
  final ValueChanged<int>? onChanged;

  final int maxValue;

  static int _maxValueOfDigits(int digitsCount) =>
      pow(10, digitsCount).toInt() - 1;

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late final TextEditingController _controller;
  bool canIncrement = false;
  bool canDecrement = false;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue.toString());
    _updateButtonsState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: PickerButton(
              icon: Icons.remove,
              onPressed: canDecrement ? () => value -= 1 : null,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _controller,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.maxDigits),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onTap: _selectAll,
                  onChanged: (text) {
                    setState(_updateButtonsState);
                    widget.onChanged?.call(value);
                  },
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
            child: PickerButton(
              icon: Icons.add,
              onPressed: canIncrement ? () => value += 1 : null,
            ),
          )
        ],
      );

  void _selectAll() {
    _controller.selection =
        TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
  }

  int get value =>
      _controller.text.isNotEmpty ? int.parse(_controller.text) : 0;

  void _updateButtonsState() {
    canIncrement = value < widget.maxValue;
    canDecrement = value > 0;
  }

  set value(int value) {
    final newText = value.toString();

    _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));

    setState(_updateButtonsState);

    widget.onChanged?.call(value);
  }
}

class PickerButton extends StatelessWidget {
  const PickerButton({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RoundButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
