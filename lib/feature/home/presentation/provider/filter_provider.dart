import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/presentation/provider/provider_todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterProvider = FutureProvider.family<List<todoModel>, String>((ref, category) async {

  final todoRepository = ref.watch(todoRepositoryProvider);
//Si es la categoria es pendiente, muestra los pendientes y asi con los demas
  if (category == 'Pendientes') {
    return await todoRepository
        .getFilteredTodos(0); 
  } else if (category == 'Completas') {
    return await todoRepository
        .getFilteredTodos(1);
  } else {
    final valor = await todoRepository.getAllTodo();
    return valor;
  }
});

final expandedTaskIndexProvider = StateProvider<int>((ref) => -1);



