import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homo_habitus/round_indicator.dart';

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
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              sliver: SliverFixedExtentList(delegate: SliverChildBuilderDelegate(
                  (context, index) => SectionLabel(),
                childCount: 1
              ), itemExtent: 30),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => Center(
                        child: RoundIndicator(
                              height: 78,
                              width: 78,
                              progressValue: 0.4,
                              icon: Icons.book,
                              onPressed: () {},
                            ),
                      ),
                      childCount: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12)),
            )
          ],
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
          Text(
            "47%",
            style: Theme.of(context).textTheme.subtitle1,
          )
        ],
      );
}
