import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;

  const RoundButton({Key? key, this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Ink(
      decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          shape: const CircleBorder()),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
      ));
}