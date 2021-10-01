import 'package:flutter/material.dart';

class FrameTile extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const FrameTile({Key? key, this.onTap, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: 0.6,
        heightFactor: 0.6,
        child: child,
      ),
    );
  }
}
