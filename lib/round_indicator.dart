import 'package:flutter/material.dart';

class RoundIndicator extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;

  const RoundIndicator({Key? key, this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Ink(
      height: 72,
      width: 72,
      decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          shape: const CircleBorder()),
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          const SizedBox(
            width: 65,
            height: 65,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              value: 0.4,
            ),
          ),
          IconButton(
            iconSize: 38,
            onPressed: onPressed,
            icon: Icon(icon),
          ),
        ],
      ));
}