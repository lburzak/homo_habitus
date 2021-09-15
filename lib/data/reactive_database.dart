import 'package:homo_habitus/data/app_database.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

class ReactiveDatabase {
  final Database _db;
  final Subject<DataEvent> _events = BehaviorSubject<DataEvent>();

  Stream<DataEvent> get events => _events.stream;

  ReactiveDatabase.wrap(Database database) : _db = database;

  static Future<ReactiveDatabase> open() async =>
      ReactiveDatabase.wrap(await openAppDatabase());

  Future<int> insert(String table, Map<String, Object?> map,
      {DataEvent? event, List<DataEvent>? events}) async {
    final result = await _db.insert(table, map);

    if (event != null) {
      _events.add(event);
    }

    events?.forEach(_events.add);

    return result;
  }

  Future<List<Object?>> commitBatch(Batch batch, DataEvent? event) async {
    final result = await batch.commit();

    _events.add(event!);

    return result;
  }

  Batch batch() => _db.batch();

  Future<List<Map<String, Object?>>> rawQuery(String sql,
      [List<Object?>? arguments]) async {
    return await _db.rawQuery(sql, arguments);
  }
}

class DataEvent {}

class HabitCreatedEvent extends DataEvent {
  Habit createdHabit;
  Goal createdGoal;

  HabitCreatedEvent({required this.createdHabit, required this.createdGoal});
}
