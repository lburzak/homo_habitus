import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homo_habitus/repository/habit_repository.dart';

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
        theme: ThemeData(
            colorScheme: const ColorScheme.dark(
                onBackground: Color(0xff393939), primary: Color(0xff306F1A)),
            iconTheme: const IconThemeData(color: Color(0xffBEBEBE)),
            appBarTheme: AppBarTheme(
                toolbarHeight: 80,
                centerTitle: true,
                elevation: 0,
                titleTextStyle: Theme.of(context).textTheme.headline6,
            textTheme: TextTheme(
              headline6: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 24),
            ),
            backwardsCompatibility: true,
              backgroundColor: Colors.transparent),
          textTheme: TextTheme(
            headline4: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 36),
              headline5: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: const Color(0xff7d7d7d)),
              headline6: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300, fontSize: 24),
              subtitle1: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 18),
            )),
        routes: {
          "/": (context) => const HomePage(),
          "/habit": (context) => const HabitPage(),
        },
      ),
    );
  }
}
