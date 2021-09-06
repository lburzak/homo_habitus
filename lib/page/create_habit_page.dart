import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:homo_habitus/widget/duration_picker.dart';
import 'package:homo_habitus/widget/option_selector.dart';
import 'package:homo_habitus/widget/round_button.dart';

class CreateHabitPage extends StatelessWidget {
  CreateHabitPage({Key? key}) : super(key: key);

  final _goalOptionController = OptionController(initialIndex: 1);
  final _habitNameController = TextEditingController();

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
                    children: [
                      const IconSelection(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            height: 32,
                            child: TextField(
                              controller: _habitNameController,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration.collapsed(
                                  hintText: "Name"),
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
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: RoundButton(icon: Icons.remove, onPressed: () {},),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: TextEditingController(text: "0"),
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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: RoundButton(
                                                icon: Icons.add,
                                                onPressed: () {},
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SizedBox(height: 120, child: DurationPicker()),
                                      ))
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: FormSection("Repetition",
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
                        )),
                  )
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
