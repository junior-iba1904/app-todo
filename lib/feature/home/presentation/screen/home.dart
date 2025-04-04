import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/presentation/provider/filter_provider.dart';
import 'package:app_todo/feature/home/presentation/provider/provider_todo.dart';
import 'package:app_todo/feature/home/presentation/provider/theme_provider.dart';
import 'package:app_todo/feature/home/presentation/screen/filter.dart';
import 'package:app_todo/feature/home/presentation/screen/order.dart';
import 'package:app_todo/feature/home/presentation/screen/widget/widget_add_edit_item_dialog.dart';
import 'package:app_todo/feature/home/presentation/screen/widget/widget_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _addTask(todoModel newTask) async {
    await ref.read(insertTodoProvider).call(newTask);
    //final taskWithId = newTask.copyWith(id: id);

    // Actualiza el proveedor y espera la nueva lista
    final updatedTasks = await ref.refresh(filterProvider('Todos').future);
    ref.invalidate(getAllTodosProvider);

    // Agrega la animación solo si hay nuevas tareas
    _listKey.currentState?.insertItem(updatedTasks.length - 1);
  }


  void _removeTask(int index) {

    final tasks = ref.read(filterProvider('Todos')).value ?? [];
    if (index >= tasks.length) {
      print("Índice fuera de rango en _removeTask: $index");
      return;
    }

    final taskToRemove = tasks[index];

    const animationDuration = Duration(milliseconds: 300);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        key: ValueKey(taskToRemove.id),
        child: TaskItem(
            data: taskToRemove,
            mode: 1,
            onEdit: null,
            onDelete: null,
            onTap: null
            ),
      ),
      duration: animationDuration,
    );

    Future.delayed(animationDuration).then((_) async {
      try {

        await ref.read(deleteTodoProvider).call(taskToRemove.id!);
        ref.invalidate(filterProvider);
        ref.invalidate(getAllTodosProvider);
      } catch (e) {
        print("Error al eliminar tarea de la BBDD: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //final selectedFilter = ref.watch(selectedFilterProvider);
    final todoAll = ref.watch(filterProvider('Todos'));

    final selectedIndex = ref.watch(expandedTaskIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final allTasks = ref.watch(filterProvider('Todos'));
            final pendingCount =
                allTasks.value?.where((task) => task.status == 0).length ?? 0;

            return Text(
              'Lista de Tareas ($pendingCount pendientes)',
              style: TextStyle(fontSize: 18),
            );
          },
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
              return Switch(
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              //ref.read(selectedFilterProvider.notifier).state = value;
              if (value == 'filter') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Filter()));
              }

              if (value == 'order') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Order()));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'filter',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.filter_list, color: Colors.amber),
                    Text(
                      'Filtrar',
                      style:
                          TextStyle(fontFamily: 'Outfit', color: Colors.amber),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'order',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.gif_box, color: Colors.green),
                    Text(
                      'Ordenar tareas',
                      style:
                          TextStyle(fontFamily: 'Outfit', color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: todoAll.when(
          data: (tasks) {
            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  'Lista vacía',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit'),
                ),
              );
            }

            return AnimatedList(
                key: _listKey,
                initialItemCount: tasks.length,
                itemBuilder: (context, index, animation) {
                  final task = tasks[index];
                  bool isExpanded = selectedIndex == index;
                  return SizeTransition(
                    key: ValueKey(task.id),
                    sizeFactor: animation,
                    child: TaskItem(
                      //key: ValueKey(task.id),
                      data: task,
                      isExpanded: isExpanded,
                      onEdit: () {
                        showDialog(
                          // Usa showDialog para editar
                          context: context,
                          builder: (BuildContext context) {
                            return AddItemDialog(
                              existingItem: task, // Pasa la tarea existente
                              onAddItem: _addTask,
                            );
                          },
                        );
                      },
                      onDelete: () => _removeTask(index),
                      onTap: () {
                        final currentIndex =
                            ref.read(expandedTaskIndexProvider);
                        ref.read(expandedTaskIndexProvider.notifier).state =
                            (currentIndex == index) ? -1 : index;
                      },
                      mode: 1,
                    ),
                  );
                });
          },
          error: (error, stackTrace) => const Center(
                child: Text('Error'),
              ),
          loading: () => const Center(child: CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            // Usa showDialog para mostrar AddItemDialog
            context: context,
            builder: (BuildContext context) {
              return AddItemDialog(onAddItem: _addTask);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
