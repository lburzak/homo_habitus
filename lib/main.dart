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
          colorScheme: const ColorScheme.dark(onBackground: Color(0xff393939)),
          primarySwatch: Colors.green,
          textTheme: TextTheme(
            headline6:
                GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 24),
            subtitle1:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
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
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today", style: Theme.of(context).textTheme.headline6),
              Text(
                "47%",
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
          RoundIndicator(
            icon: Icons.fitness_center,
            onPressed: () {},
          )
        ],
      );
}

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