import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/presentation/provider/filter_provider.dart';
import 'package:app_todo/feature/home/presentation/provider/provider_todo.dart';
import 'package:app_todo/feature/home/presentation/screen/widget/widget_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Order extends ConsumerStatefulWidget {
  const Order({super.key});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends ConsumerState<Order> {
  List<todoModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    tasks = await ref.read(getAllTodosProvider.future);
    //print("Tareas cargadas: $tasks");
    setState(() {});
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
  if (newIndex > oldIndex) newIndex--;
  final task = tasks.removeAt(oldIndex);
  tasks.insert(newIndex, task);

  setState(() {});

  try {
    for (int i = 0; i < tasks.length; i++) {
      final updatedTask = tasks[i];
      ref.read(updatePositionTodoProvider).call(updatedTask.id!, i);
    }
    ref.invalidate(filterProvider);

  } catch (e) {
    print("Error al actualizar posiciones en BBDD: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ordenar Tareas')),
      body: tasks.isEmpty
          ? Center(child: Text("No hay tareas"))
          : ReorderableListView(
              onReorder: _onReorder,
              header: Text('Mantenga presiona una tarea y muevalo'),
              children: [
                for (int i = 0; i < tasks.length; i++)
                  TaskItem(
                    key: ValueKey(tasks[i].id),
                    data: tasks[i],
                  ),
              ],
            ),
    );
  }
}
