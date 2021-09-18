import 'package:homo_habitus/data/data_event.dart';
import 'package:homo_habitus/data/database_schema.dart';
import 'package:sqflite/sqflite.dart';

class ProgressRepository {
  final Database _db;
  final DataEventBus _dataEventBus;

  ProgressRepository(this._db, this._dataEventBus);

  Future<void> addProgress(int habitId, int progressValue) async {
    await _db
        .rawQuery(Queries.addProgressToCurrentGoal, [habitId, progressValue]);
    _dataEventBus.emit(HabitChangedEvent(habitId));
  }
}