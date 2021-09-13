import 'dart:async';

import 'package:homo_habitus/data/database_schema.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/repository/habit_repository.dart';
import 'package:sqflite/sqflite.dart';

class HabitDao {
  HabitDao(this.db);

  static const String table = Tables.habit;
  final Database db;

  final StreamController<void> _dataChangesController =
      StreamController.broadcast();

  Stream<void> get _dataChanges => _dataChangesController.stream;

  Future<int> insert(Habit habit) async {
    final id = await db.insert(table, habit.toMap());
    _notifyDataChanged();
    return id;
  }

  Stream<List<Habit>> watch() => _dataChanges.asyncMap((_) async =>
      (await db.query(table)).map((results) => habitFromMap(results)).toList());

  void _notifyDataChanged() {
    _dataChangesController.add(null);
  }
}
