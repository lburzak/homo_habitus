import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateHabitPage extends StatelessWidget {
  const CreateHabitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('New habit'),
    )
  );
}