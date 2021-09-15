import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/page/create_habit_page.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/theme.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'data/app_database.dart';
import 'data/reactive_database.dart';
import 'page/habit_page.dart';
import 'page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReactiveDatabase>(
      future: ReactiveDatabase.open(),
      builder: (context, snapshot) => snapshot.hasData
          ? Provider<ReactiveDatabase>.value(
              value: snapshot.data!,
              child: RepositoryProvider(
                create: (context) =>
                    HabitRepository(context.read<ReactiveDatabase>()),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Homo Habitus',
                  theme: themeData,
                  routes: {
                    "/": (context) => const HomePage(),
                    "/habit": (context) => const HabitPage(),
                    "/create_habit": (context) => const CreateHabitPage()
                  },
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
