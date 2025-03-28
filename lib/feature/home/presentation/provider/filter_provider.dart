import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/presentation/provider/provider_todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterProvider = FutureProvider.family<List<todoModel>, String>((ref, category) async {

  final todoRepository = ref.watch(todoRepositoryProvider);

  if (category == 'Pendientes') {
    return await todoRepository
        .getFilteredTodos(0); 
  } else if (category == 'Completas') {
    return await todoRepository
        .getFilteredTodos(1);  // 1 = Completa
  } else {
    final valor = await todoRepository.getAllTodo();
    return valor; // Retorna todas las metas // Todas las tareas
  }
});

final expandedTaskIndexProvider = StateProvider<int>((ref) => -1);



