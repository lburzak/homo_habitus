import 'dart:async';

import 'package:homo_habitus/data/data_event.dart';
import 'package:homo_habitus/data/habit_dao.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/icon_asset.dart';

class HabitRepository {
  final HabitDao _habitDao;
  final DataEventBus _dataEventBus;

  HabitRepository(this._habitDao, this._dataEventBus);

  Stream<DataEvent> get _events => _dataEventBus.events;

  Stream<List<Habit>> watchAllHabits() async* {
    yield await _habitDao.getTodayHabits();

    yield* _events
        .where(
            (event) => event is HabitCreatedEvent || event is HabitChangedEvent)
        .asyncMap((event) => _habitDao.getTodayHabits());
  }

  Stream<Habit> watchHabit(int id) async* {
    yield await _habitDao.getHabitById(id);

    yield* _events
        .where((event) => event is HabitChangedEvent && event.habitId == id)
        .asyncMap((event) => _habitDao.getHabitById(id));
  }

  Future<void> createHabit(
      {required String name,
      required IconAsset icon,
      required Goal goal}) async {
    _habitDao.createHabit(name: name, icon: icon, goal: goal);
    _dataEventBus.emit(HabitCreatedEvent());
  }
}
