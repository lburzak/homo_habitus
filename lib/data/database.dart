import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@UseMoor(
  include: {'tables.moor'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final databaseDirectory = await getApplicationDocumentsDirectory();
    final file = File(path.join(databaseDirectory.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}
