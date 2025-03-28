import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/domain/repositories/todo_repository.dart';

class InsertTodoUseCase {
  final todoRepository repository;

  InsertTodoUseCase(this.repository);

  Future<void> call(todoModel data) {
    return repository.insertTodo(data);
  }
}