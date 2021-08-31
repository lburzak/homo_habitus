import 'package:homo_habitus/model/goal.dart';

class Habit {
  int id;
  String name;
  int iconCodePoint;
  Goal goal;

  Habit({required this.id, required this.name, required this.iconCodePoint, required this.goal});
}