import 'package:homo_habitus/data/database.dart';

class ProgressRepository {
  final AppDatabase _db;

  ProgressRepository(this._db);

  Future<void> addProgress(int habitId, int progressValue) async {
    final entity =
        ProgressEventsCompanion.insert(habitId: habitId, value: progressValue);
    await _db.into(_db.progressEvents).insert(entity);
  }
}