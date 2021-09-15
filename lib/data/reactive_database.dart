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
      {List<DataEvent>? events}) async {
    final result = await _db.insert(table, map);

    events?.forEach(_events.add);

    return result;
  }
}

class DataEvent {}

class HabitCreatedEvent extends DataEvent {
  Habit createdHabit;
  Goal createdGoal;

  HabitCreatedEvent({required this.createdHabit, required this.createdGoal});
}
