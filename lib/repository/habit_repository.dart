import 'dart:async';

import 'package:homo_habitus/data/data_event.dart';
import 'package:homo_habitus/data/habit_dao.dart';
import 'package:homo_habitus/model/goal.dart';
import 'package:homo_habitus/model/habit.dart';
import 'package:homo_habitus/model/icon_asset.dart';
import 'package:rxdart/rxdart.dart';

class HabitRepository {
  final HabitDao _habitDao;
  final DataEventBus _dataEventBus;
  List<Habit> habitsCache = [];
  StreamSubscription? habitsUpdateSubscription;

  HabitRepository(this._habitDao, this._dataEventBus);

  Stream<DataEvent> get _events => _dataEventBus.events;

  late final Subject<List<Habit>> _allHabits = BehaviorSubject.seeded([],
      onListen: _onListSubscription, onCancel: _onListSubscriptionCancel);

  Stream<List<Habit>> get allHabits => _allHabits.stream;

  Stream<Habit> watchHabit(int id) async* {
    final cacheIndex = habitsCache.indexWhere((element) => element.id == id);

    if (cacheIndex != -1) {
      yield habitsCache[cacheIndex];
    } else {
      yield await _habitDao.getHabitById(id);
    }

    yield* _events
        .where((event) => event is HabitChangedEvent && event.habitId == id)
        .asyncMap((event) => _habitDao.getHabitById(id));
  }

  Future<void> createHabit(
      {required String name,
      required IconAsset icon,
      required Goal goal}) async {
    _habitDao.createHabit(name: name, icon: icon, goal: goal);
    _emit(HabitCreatedEvent());
  }

  void _emit(DataEvent event) {
    _dataEventBus.emit(event);
  }

  void _onListSubscription() async {
    _habitDao.getTodayHabits().then(_updateList);

    habitsUpdateSubscription = _events
        .where(
            (event) => event is HabitCreatedEvent || event is HabitChangedEvent)
        .asyncMap((event) => _habitDao.getTodayHabits())
        .listen((habits) {
      _updateList(habits);
    });
  }

  void _onListSubscriptionCancel() {
    habitsUpdateSubscription?.cancel();
  }

  void _updateList(List<Habit> newList) {
    habitsCache = newList;
    _allHabits.add(newList);
  }
}
