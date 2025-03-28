import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteTodoLocalDatasource {
  Database? _database;
  int dbVersion = 5;

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    try {
      String path = await getDatabasesPath();
      return openDatabase(
        join(path, 'lista_$dbVersion.db'),
        onCreate: (database, version) async {
          await database.execute(
            "CREATE TABLE todoTable(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, estado INTEGER NOT NULL)",
          );
          deleteOldDatabases();
        },
        version: 1,
      );
    } catch (e) {
      throw Exception("ERROR al inicializar la base de datos: $e");
    }
  }

  //Elimina las bases de datos anteriores
  Future<void> deleteOldDatabases() async {
    for (int i = 1; i < dbVersion; i++) {
      String dbName = 'lista_${i}.db';
      await deleteDatabase(dbName);
    }
  }
}