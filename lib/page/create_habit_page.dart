import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homo_habitus/widget/option_selector.dart';

class CreateHabitPage extends StatelessWidget {
  CreateHabitPage({Key? key}) : super(key: key);

  final _goalOptionController = OptionController();

  @override
  Widget build(BuildContext context) =>
      Scaffold(
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
                              height: 48,
                              child: OptionSelector(
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
                              ),
                            ),
                            ValueListenableBuilder<int>(
                                valueListenable: _goalOptionController.selectedIndex,
                                builder: (context, value, child) =>
                                value == 0
                                    ? Text("30 times")
                                    : Text("for 30 minutes"))
                          ],
                        ),
                      )),
                  FormSection("Repetition",
                      child: Material(
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          height: 48,
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
