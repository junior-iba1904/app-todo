import 'package:app_todo/feature/home/data/datasource/todo_local_datasource.dart';
import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/domain/repositories/todo_repository.dart';
import 'package:sqflite/sqflite.dart';

class TodoRepositoryImpl implements todoRepository {
  final SQLiteTodoLocalDatasource localDatasource = SQLiteTodoLocalDatasource();

  Future<Database> get _database async => await localDatasource.getDatabase();

  @override
  Future<void> insertTodo(todoModel mainTable) async {
    final db = await _database;
    await db.insert('todoTable', mainTable.toJson());
  }

  @override
Future<List<todoModel>> getAllTodo() async {
  final db = await _database;
  final List<Map<String, dynamic>> queryResult =
      await db.rawQuery('SELECT * FROM todoTable');

  return queryResult.map((e) => todoModel.fromJson(e)).toList();
}


  @override
  Future<void> updateTodo(todoModel mainTable) async {
    final db = await _database;
    await db.update(
      'todoTable',
      mainTable.toJson(),
      where: 'id = ?',
      whereArgs: [mainTable.id],
    );
  }

  @override
  Future<void> deleteTodo(int id) async {
    final db = await _database;
    await db.delete('todoTable', where: 'id = ?', whereArgs: [id]);
  }

  @override
Future<List<todoModel>> getFilteredTodos(int status) async {
  final db = await _database;
  final List<Map<String, dynamic>> queryResult = await db.rawQuery(
      'SELECT * FROM todoTable WHERE estado = ?', [status]);

  return queryResult.map((e) => todoModel.fromJson(e)).toList();
}

@override
  Future<void> updateTodoStatus(int todoId, int Status) async {
  final db = await _database;
  await db.update(
    'todoTable',
    {'estado': Status},
    where: 'id = ?',
    whereArgs: [todoId],
  );
}

}