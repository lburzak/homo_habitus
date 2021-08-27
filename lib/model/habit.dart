import 'package:homo_habitus/model/goal.dart';

class Habit {
  String name;
  int iconCodePoint;
  Goal goal;

  Habit({required this.name, required this.iconCodePoint, required this.goal});
}