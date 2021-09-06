import 'package:flutter/material.dart';

class WheelPicker<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T)? buildChild;

  const WheelPicker({Key? key, required this.items})
      : buildChild = null,
        super(key: key);

  const WheelPicker.builder(
      {Key? key, required this.items, required this.buildChild})
      : super(key: key);

  Widget _buildChildDefault(T item) => Text(item.toString());

  List<Widget> _buildChildren() =>
      items.map(buildChild ?? _buildChildDefault).toList();

  @override
  Widget build(BuildContext context) => ListWheelScrollView(
    physics: const BouncingScrollPhysics(),
    itemExtent: 30,
    children: _buildChildren(),
    overAndUnderCenterOpacity: 0.5,
  );
}

class NumberPicker extends WheelPicker<int> {
  final int min;
  final int max;
  final int step;

  static List<int> _createItems(int min, int max, int step) {
    List<int> items = [];

    for (int i = min; i <= max; i += step) {
      items.add(i);
    }

    return items;
  }

  NumberPicker({Key? key, required this.min, required this.max, this.step = 1})
      : super(key: key, items: _createItems(min, max, step));

  NumberPicker.builder(
      {Key? key,
        required this.min,
        required this.max,
        required this.step,
        required Widget Function(int) buildChild})
      : super.builder(
      key: key,
      items: _createItems(min, max, step),
      buildChild: buildChild);
}
