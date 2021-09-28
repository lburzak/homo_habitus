import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/icon_asset.dart';

class Habit {
  int id;
  String name;
  IconAsset icon;
  Goal goal;

  Habit(
      {required this.id,
      required this.name,
      required this.icon,
      required this.goal});

  static Habit placeholder() => Habit(
      id: 12,
      name: "name",
      icon: IconAsset.placeholder(),
      goal: Goal.placeholder());

  @override
  String toString() {
    return 'Habit{id: $id, name: $name, icon: $icon}';
  }
}