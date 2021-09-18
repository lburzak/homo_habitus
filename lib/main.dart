import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homo_habitus/data/app_database.dart';
import 'package:homo_habitus/data/habit_dao.dart';
import 'package:homo_habitus/page/create_habit_page.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:homo_habitus/repository/progress_repository.dart';
import 'package:homo_habitus/theme.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'data/data_event.dart';
import 'page/habit_page.dart';
import 'page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      future: openAppDatabase(),
      builder: (context, snapshot) => snapshot.hasData
          ? Provider<Database>.value(
              value: snapshot.data!,
              child: MultiProvider(
                providers: [
                  Provider(create: (context) => DataEventBus()),
                  Provider(
                      create: (context) => HabitDao(context.read<Database>()))
                ],
                child: MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider(
                        create: (context) => HabitRepository(
                            context.read<HabitDao>(),
                            context.read<DataEventBus>())),
                    RepositoryProvider(
                        create: (context) => ProgressRepository(
                            context.read<Database>(),
                            context.read<DataEventBus>())),
                  ],
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
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
