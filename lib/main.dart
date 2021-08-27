import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Homo Habitus',
      theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          primarySwatch: Colors.green,
          textTheme: TextTheme(
              headline6: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300, fontSize: 24),
              subtitle1: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
          )),
      home: const Scaffold(
        body: HabitsPage(),
      ),
    );
  }
}

class HabitsPage extends StatelessWidget {
  const HabitsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: SectionLabel(),
        ),
      );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Today", style: Theme.of(context).textTheme.headline6),
          Text("47%", style: Theme.of(context).textTheme.subtitle1,)
        ],
      );
}
