import 'package:sqflite/sqflite.dart';

import 'database_schema.dart';

const databaseVersion = 1;
const databasePath = "homo_habiticus.db";

Future<Database> openAppDatabase() async {
  return await openDatabase(databasePath,
      version: databaseVersion, onCreate: _createTables);
}

Future<void> _createTables(Database db, int version) async {
  db.execute(Queries.createGoalTypeTable);
  db.execute(Queries.populateGoalTypeTable);

  db.execute(Queries.createTimeframeTable);
  db.execute(Queries.populateTimeframeTable);

  db.execute(Queries.createHabitTable);
  db.execute(Queries.createGoalTable);
}
