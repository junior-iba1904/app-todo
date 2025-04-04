import 'package:app_todo/feature/home/domain/repositories/todo_repository.dart';

class UpdatePositionCaseUse {
  final todoRepository repository;

  UpdatePositionCaseUse(this.repository);

  Future<void> call(int id, int newPosition) {
    return repository.updateTodoPosition(id, newPosition);
  }
}
