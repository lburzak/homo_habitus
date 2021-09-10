import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homo_habitus/util/extensions.dart';

class OptionSelector<T> extends StatefulWidget {
  const OptionSelector(
      {Key? key, required this.options, this.onChange})
      : super(key: key);

  final List<Option<T>> options;
  final void Function(T)? onChange;

  @override
  State<OptionSelector<T>> createState() => _OptionSelectorState<T>();
}

class _OptionSelectorState<T> extends State<OptionSelector<T>> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onBackground,
      clipBehavior: Clip.hardEdge,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.options
            .mapIndexed((option, index) => OptionView(
          option,
          selected: index == selectedIndex,
          onTap: index != selectedIndex
              ? () {
            setState(() {
              selectedIndex = index;
              widget.onChange!(widget.options[index].value);
            });
          }
              : null,
        ))
            .toList(),
      ),
    );
  }
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
