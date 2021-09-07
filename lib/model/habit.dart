class Habit {
  int id;
  String name;
  String iconName;

  Habit(
      {required this.id,
      required this.name,
      required this.iconName});

  @override
  String toString() {
    return 'Habit{id: $id, name: $name, iconName: $iconName}';
  }
}