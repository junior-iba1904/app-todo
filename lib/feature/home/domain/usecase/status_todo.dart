import 'package:app_todo/feature/home/domain/repositories/todo_repository.dart';

class StatusTodoUseCase {
  final todoRepository repository;

  StatusTodoUseCase(this.repository);

  Future<void> call(int todoId, int Status) {
    return repository.updateTodoStatus(todoId, Status);
  }
}