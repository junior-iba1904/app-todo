import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/domain/repositories/todo_repository.dart';

class GetFilteredTodosUseCase {
  final todoRepository repository;

  GetFilteredTodosUseCase(this.repository);

  Future<List<todoModel>> call(int status) async {
    return await repository.getFilteredTodos(status);
  }
}