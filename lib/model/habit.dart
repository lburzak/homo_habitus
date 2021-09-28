import 'package:homo_habitus/model/icon_asset.dart';
import 'package:homo_habitus/model/progress.dart';

class Habit {
  int id;
  String name;
  IconAsset icon;
  Progress progress;

  Habit(
      {required this.id,
      required this.name,
      required this.icon,
      required this.progress});

  @override
  String toString() {
    return 'Habit{id: $id, name: $name, icon: $icon}';
  }
}