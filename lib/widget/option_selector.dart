import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homo_habitus/util/extensions.dart';

class OptionSelector extends StatelessWidget {
  OptionSelector(
      {Key? key, required this.options, OptionController? controller})
      : super(key: key) {
    _controller = controller ?? OptionController();
  }

  final List<Option> options;
  late final OptionController _controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onBackground,
      clipBehavior: Clip.hardEdge,
      child: ValueListenableBuilder(
        valueListenable: _controller.selectedIndex,
        builder: (context, selectedIndex, child) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: options
              .mapIndexed((option, index) => OptionView(
                    option,
                    selected: index == selectedIndex,
                    onTap: index != selectedIndex
                        ? () {
                            _controller.selectIndex(index);
                          }
                        : null,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class OptionController {
  final int initialIndex;
  final ValueNotifier<int> _selectedIndex;

  ValueListenable<int> get selectedIndex => _selectedIndex;

  void selectIndex(int value) {
    _selectedIndex.value = value;
  }

  OptionController({this.initialIndex = 0})
      : _selectedIndex = ValueNotifier(initialIndex);
}

class Option<T> {
  final T value;
  final String label;
  final Icon? leading;

  Option(this.value, {this.leading, String? label}) : label = label ?? value.toString();
}

class OptionView extends StatelessWidget {
  const OptionView(this.option, {Key? key, this.selected = false, this.onTap})
      : super(key: key);

  final Option option;
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Material(
      color:
          selected ? Colors.transparent : Theme.of(context).colorScheme.background.withAlpha(30),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: option.leading ?? const SizedBox.shrink(),
                )),
            Align(
              alignment: Alignment.center,
              child: Text(
                option.label,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
