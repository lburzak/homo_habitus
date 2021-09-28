import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homo_habitus/widget/round_button.dart';

class NumberPicker extends StatefulWidget {
  const NumberPicker(
      {Key? key,
      required this.maxDigits,
      this.onChanged,
      this.initialValue = 0})
      : super(key: key);

  final int maxDigits;
  final int initialValue;
  final ValueChanged<int>? onChanged;

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: PickerButton(
              icon: Icons.remove,
              onPressed: () => value -= 1,
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
                  onChanged: (text) => widget.onChanged?.call(value),
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
              onPressed: () => value += 1,
            ),
          )
        ],
      );

  void _selectAll() {
    _controller.selection =
        TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
  }

  int get value => int.parse(_controller.text);

  set value(int value) {
    final newText = value.toString();

    _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));

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
