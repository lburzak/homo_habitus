import 'package:homo_habitus/data/database_schema.dart';
import 'package:homo_habitus/data/reactive_database.dart';

class ProgressRepository {
  final ReactiveDatabase db;

  ProgressRepository(this.db);

  Future<void> addProgress(int habitId, int progressValue) async {
    await db.rawQuery(Queries.addProgressToCurrentGoal, [habitId, progressValue]);
    db.emitEvent(ProgressChangedEvent(affectedHabitId: habitId));
  }
}
