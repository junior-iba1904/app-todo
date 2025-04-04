import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/data/repositories/todo_repository_impl.dart';
import 'package:app_todo/feature/home/domain/repositories/todo_repository.dart';
import 'package:app_todo/feature/home/domain/usecase/add_todo.dart';
import 'package:app_todo/feature/home/domain/usecase/all_todo.dart';
import 'package:app_todo/feature/home/domain/usecase/delete_todo.dart';
import 'package:app_todo/feature/home/domain/usecase/filter_todo.dart';
import 'package:app_todo/feature/home/domain/usecase/status_todo.dart';
import 'package:app_todo/feature/home/domain/usecase/update_position.dart';
import 'package:app_todo/feature/home/domain/usecase/update_todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//los providers para cada caso de uso

final todoRepositoryProvider = Provider<todoRepository>((ref) {
  return TodoRepositoryImpl();
});

final insertTodoProvider = Provider((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return InsertTodoUseCase(repository);
});


final getAllTodosProvider = FutureProvider((ref) async {
  final repository = ref.read(todoRepositoryProvider);
  final useCase = GetAllTodosUseCase(repository);
  return useCase.call();
});

final updateTodoProvider = Provider((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return UpdateTodoUseCase(repository);
});

final deleteTodoProvider = Provider((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return DeleteTodoUseCase(repository);
});

final getFilteredTodosProvider = FutureProvider.family<List<todoModel>, int>((ref, status) async {
  final repository = ref.read(todoRepositoryProvider);
  final useCase = GetFilteredTodosUseCase(repository);
  return useCase.call(status);
});

final updateTodoStatusProvider = Provider((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return StatusTodoUseCase(repository);
});

final updatePositionTodoProvider = Provider((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return UpdatePositionCaseUse(repository);
});
