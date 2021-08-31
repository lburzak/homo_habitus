import 'package:homo_habitus/model/goal.dart';

class Habit {
  int id;
  String name;
  String iconName;
  Goal goal;

  Habit(
      {required this.id,
      required this.name,
      required this.iconName,
      required this.goal});
}