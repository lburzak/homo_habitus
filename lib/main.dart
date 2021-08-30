import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/theme.dart';

import 'page/habit_page.dart';
import 'page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HabitRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Homo Habitus',
        theme: themeData,
        routes: {
          "/": (context) => const HomePage(),
          "/habit": (context) => const HabitPage(),
        },
      ),
    );
  }
}
