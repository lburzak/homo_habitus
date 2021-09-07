import 'package:flutter/material.dart';

class WheelPicker<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T)? buildChild;
  final void Function(T)? onSelectedItemChanged;

  const WheelPicker({Key? key, required this.items, this.onSelectedItemChanged})
      : buildChild = null,
        super(key: key);

  const WheelPicker.builder(
      {Key? key,
      required this.items,
      required this.buildChild,
      this.onSelectedItemChanged})
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
        onSelectedItemChanged: (index) => onSelectedItemChanged!(items[index]),
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

  NumberPicker(
      {Key? key,
      required this.min,
      required this.max,
      this.step = 1,
      void Function(int)? onSelectedItemChanged})
      : super(
            key: key,
            items: _createItems(min, max, step),
            onSelectedItemChanged: onSelectedItemChanged);

  NumberPicker.builder(
      {Key? key,
      required this.min,
      required this.max,
      required this.step,
      required Widget Function(int) buildChild,
      void Function(int)? onSelectedItemChanged})
      : super.builder(
            key: key,
            items: _createItems(min, max, step),
            buildChild: buildChild,
            onSelectedItemChanged: onSelectedItemChanged);
}
