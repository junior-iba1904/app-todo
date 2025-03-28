import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/domain/repositories/todo_repository.dart';

class GetAllTodosUseCase {
  final todoRepository repository;

  GetAllTodosUseCase(this.repository);

  Future<List<todoModel>> call() {
    return repository.getAllTodo();
  }
}