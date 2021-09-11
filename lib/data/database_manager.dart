import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

import 'database_schema.dart';

class DatabaseManager {
  static const databaseVersion = 1;
  static const databasePath = "homo_habiticus.db";

  late Database _instance;

  final ValueNotifier<bool> _isReady = ValueNotifier(false);

  ValueListenable<bool> get isReady => _isReady;

  Database get instance => _instance;

  Future open() async {
    _instance = await openDatabase(databasePath,
        version: databaseVersion, onCreate: _createTables);

    _isReady.value = true;
  }

  Future _createTables(Database db, int version) async {
    db.execute(Queries.createGoalTypeTable);
    db.execute(Queries.populateGoalTypeTable);

    db.execute(Queries.createTimeframeTable);
    db.execute(Queries.populateTimeframeTable);

    db.execute(Queries.createHabitTable);
    db.execute(Queries.createGoalTable);
  }
}
