import 'package:flutter/material.dart';

class RoundIndicator extends StatelessWidget {
  final Icon icon;
  final double progressValue;
  final double progressStrokeWidth;
  final bool active;

  const RoundIndicator({Key? key, required this.icon, this.progressValue = 0, this.progressStrokeWidth = 3, this.active = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: Ink(
        decoration: ShapeDecoration(
            color: active ? Theme.of(context).colorScheme.primaryVariant : Theme.of(context).colorScheme.onBackground,
            shape: const CircleBorder()),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            FractionallySizedBox(
              heightFactor: 0.9,
              widthFactor: 0.9,
              child: CircularProgressIndicator(
                strokeWidth: progressStrokeWidth,
                value: progressValue,
              ),
            ),
            icon,
          ],
        )),
  );
}