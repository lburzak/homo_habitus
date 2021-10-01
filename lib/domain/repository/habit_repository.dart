import 'dart:async';

import 'package:homo_habitus/data/database.dart';
import 'package:homo_habitus/domain/model/deadline.dart';
import 'package:homo_habitus/domain/model/goal.dart';
import 'package:homo_habitus/domain/model/habit.dart';
import 'package:homo_habitus/domain/model/icon_asset.dart';
import 'package:homo_habitus/domain/model/progress.dart';

class HabitRepository {
  final AppDatabase db;

  HabitRepository(this.db);

  Stream<List<Habit>> watchHabitsByDeadline(Deadline deadline) => db
      .findHabitsByDeadline(serializeDeadline(deadline))
      .map((result) => result.extractHabit())
      .watch();

  Stream<double> watchCompletionPercentageByDeadline(Deadline deadline) => db
      .findCompletionRateByDeadline(serializeDeadline(deadline))
      .watchSingle();

  Stream<Habit> watchHabit(int id) =>
      db.findHabitById(id).map((p0) => p0.extractHabit()).watchSingle();

  Future<void> createHabit(
      {required String name,
      required IconAsset icon,
      required Goal goal}) async {
    db.into(db.habits).insert(HabitsCompanion.insert(
        name: name,
        icon: icon.name,
        trackerName: serializeTrackerName(goal.progress),
        targetProgress: serializeTargetProgress(goal.progress),
        deadlineName: serializeDeadline(goal.deadline)));
  }
}

extension Serialization on HabitCompound {
  Habit extractHabit() => Habit(
      name: name,
      icon: IconAsset.ofDefaultPath(icon),
      id: id,
      goal: extractGoal());

  Progress extractProgress() {
    switch (trackerName) {
      case 'counter':
        return CounterProgress(currentProgress, targetProgress);
      case 'timer':
        return TimerProgress(currentProgress, targetProgress);
      default:
        throw StateError("Unexpected tracker name [$trackerName]");
    }
  }

  Goal extractGoal() => Goal(
      deadline: deserializeDeadline(deadlineName), progress: extractProgress());
}

Deadline deserializeDeadline(String name) {
  switch (name) {
    case 'endOfDay':
      return Deadline.endOfDay;
    case 'endOfWeek':
      return Deadline.endOfWeek;
    case 'endOfMonth':
      return Deadline.endOfMonth;
    default:
      throw ArgumentError(
          "No matching Deadline value for name [$name]", "name");
  }
}

String serializeDeadline(Deadline deadline) {
  switch (deadline) {
    case Deadline.endOfDay:
      return 'endOfDay';
    case Deadline.endOfWeek:
      return 'endOfWeek';
    case Deadline.endOfMonth:
      return 'endOfMonth';
    default:
      throw ArgumentError("Unknown deadline [$deadline]", "deadline");
  }
}

String serializeTrackerName(Progress progress) {
  if (progress is CounterProgress) {
    return 'counter';
  } else if (progress is TimerProgress) {
    return 'timer';
  } else {
    throw ArgumentError("Unknown type of progress [$progress]", "progress");
  }
}

int serializeTargetProgress(Progress progress) {
  if (progress is CounterProgress) {
    return progress.targetCount;
  } else if (progress is TimerProgress) {
    return progress.targetMilliseconds;
  } else {
    throw ArgumentError("Unknown type of progress [$progress]", "progress");
  }
}
