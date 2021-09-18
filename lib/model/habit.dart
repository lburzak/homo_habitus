import 'package:homo_habitus/model/habit_progress.dart';

class Habit {
  int id;
  String name;
  String iconName;
  GoalProgress progress;

  Habit(
      {required this.id,
      required this.name,
      required this.iconName,
      required this.progress});

  @override
  String toString() {
    return 'Habit{id: $id, name: $name, iconName: $iconName}';
  }
}