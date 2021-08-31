import 'package:flutter/material.dart';

class RoundIndicator extends StatelessWidget {
  final Widget body;
  final double progressValue;
  final double progressStrokeWidth;
  final bool active;

  const RoundIndicator(
      {Key? key,
      required this.body,
      this.progressValue = 0,
      this.progressStrokeWidth = 3,
      this.active = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: Ink(
            decoration: ShapeDecoration(
                color: active
                    ? Theme.of(context).colorScheme.primaryVariant
                    : Theme.of(context).colorScheme.onBackground,
                shape: const CircleBorder()),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                FractionallySizedBox(
                  heightFactor: 0.9,
                  widthFactor: 0.9,
                  child: CircularProgressIndicator(
                    color: progressValue >= 1 ? Theme.of(context).colorScheme.secondary : null,
                    strokeWidth: progressStrokeWidth,
                    value: progressValue,
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: 0.5,
                  widthFactor: 0.5,
                  child: body,
                )
              ],
            )),
      );
}