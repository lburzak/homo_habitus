import 'package:flutter/material.dart';

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
            child: Material(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.onBackground,
                child: child),
          ),
        ],
      ),
    );
  }
}
