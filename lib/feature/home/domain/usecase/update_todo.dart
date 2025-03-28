import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/domain/repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final todoRepository repository;

  UpdateTodoUseCase(this.repository);

  Future<void> call(todoModel data) {
    return repository.updateTodo(data);
  }
}