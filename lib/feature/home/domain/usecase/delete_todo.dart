import 'package:app_todo/feature/home/domain/repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final todoRepository repository;

  DeleteTodoUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteTodo(id);
  }
}