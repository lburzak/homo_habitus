import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateHabitPage extends StatelessWidget {
  const CreateHabitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('New habit'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: const [
                      IconSelection(),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            height: 32,
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration.collapsed(hintText: "Name"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  FormSection("Goal",
                      child: Material(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.onBackground,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 32,
                              child: OptionSelector(
                                options: [Option("Counter"), Option("Timer")],
                              ),
                            ),
                            Text("for 30 minutes")
                          ],
                        ),
                      )),
                  FormSection("Repetition",
                      child: Material(
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          height: 32,
                          child: OptionSelector(
                            options: [
                              Option("Daily"),
                              Option("Weekly"),
                              Option("Monthly")
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      );
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

class OptionSelector extends StatefulWidget {
  const OptionSelector({
    Key? key,
    required this.options,
  }) : super(key: key);

  final List<Option> options;

  @override
  State<OptionSelector> createState() => _OptionSelectorState();
}

class _OptionSelectorState extends State<OptionSelector> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onBackground,
      clipBehavior: Clip.hardEdge,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.options
            .mapIndexed((option, index) => OptionView(
                  option.label,
                  selected: index == selectedIndex,
                  onTap: index != selectedIndex
                      ? () {
                          _selectIndex(index);
                        }
                      : null,
                ))
            .toList(),
      ),
    );
  }

  void _selectIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class Option {
  final String label;

  Option(this.label);
}

class OptionView extends StatelessWidget {
  const OptionView(this.label, {Key? key, this.selected = false, this.onTap})
      : super(key: key);

  final String label;
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Material(
      color:
          selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}

class IconSelection extends StatelessWidget {
  const IconSelection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 64,
      child: Ink(
          decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              shape: const CircleBorder()),
          child: const FractionallySizedBox(
            heightFactor: 0.5,
            widthFactor: 0.5,
            child: Icon(Icons.extension),
          )),
    );
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E element, int index) toElement) {
    var index = 0;
    return map((item) => toElement(item, index++));
  }
}
