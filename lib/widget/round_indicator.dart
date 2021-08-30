import 'package:flutter/material.dart';

class RoundIndicator extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;
  final double height;
  final double width;
  final double progressValue;
  final double progressStrokeWidth;
  final bool active;

  const RoundIndicator({Key? key, this.onPressed, required this.icon, this.height = 72, this.width = 72, this.progressValue = 0, this.progressStrokeWidth = 3, this.active = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Ink(
      height: height,
      width: width,
      decoration: ShapeDecoration(
          color: active ? Theme.of(context).colorScheme.primaryVariant : Theme.of(context).colorScheme.onBackground,
          shape: const CircleBorder()),
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 0.9 * width,
            height: 0.9 * height,
            child: CircularProgressIndicator(
              strokeWidth: progressStrokeWidth,
              value: progressValue,
            ),
          ),
          IconButton(
            iconSize: 0.6 * height,
            onPressed: onPressed,
            icon: Icon(icon),
          ),
        ],
      ));
}