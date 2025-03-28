import 'package:app_todo/feature/home/data/models/todoModel.dart';

abstract class todoRepository {
  Future<void> insertTodo(todoModel data);
  Future<List<todoModel>> getAllTodo();
  Future<void> updateTodo(todoModel data);
  Future<void> deleteTodo(int id);
  Future<List<todoModel>> getFilteredTodos(int status);
  Future<void> updateTodoStatus(int todoId, int Status);
}
