import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/presentation/provider/filter_provider.dart';
import 'package:app_todo/feature/home/presentation/provider/provider_todo.dart';
import 'package:app_todo/feature/home/presentation/provider/theme_provider.dart';
import 'package:app_todo/feature/home/presentation/screen/widget/widget_customImputField.dart';
import 'package:app_todo/feature/home/presentation/screen/widget/widget_task.dart';
import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filter = [
      'Todos',
      'Pendientes',
      'Completas',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Consumer(
    builder: (context, ref, child) {
      final allTasks = ref.watch(filterProvider('Todos'));
      final pendingCount = allTasks.value?.where((task) => task.status == 0).length ?? 0;
      
      return Text('Lista de Tareas ($pendingCount pendientes)', style: TextStyle(fontSize: 20),);
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
        ],
      ),
      body: DefaultTabController(
          length: filter.length,
          child: Column(
            children: [
              ButtonsTabBar(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  buttonMargin:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  backgroundColor: Theme.of(context).primaryColor,
                  unselectedBackgroundColor: Theme.of(context).hoverColor,
                  unselectedLabelStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  tabs: filter.map((filtername) {
                    return Tab(
                      text: filtername,
                    );
                  }).toList()),
              Expanded(
                child: TabBarView(
                  children: filter.map((category) {
                    return Consumer(
                      builder: (context, ref, child) {
                        final todoAll = ref.watch(filterProvider(category));
                        final selectedIndex =
                            ref.watch(expandedTaskIndexProvider);

                        return todoAll.when(
                          data: (todos) => todos.isNotEmpty
                              ? ListView.builder(
                                  itemCount: todos.length,
                                  itemBuilder: (context, index) {
                                    bool isExpanded = selectedIndex == index;
                                    final data = todos[index];
                                    return TaskItem(
                                      data: data,
                                      isExpanded: isExpanded,
                                      onEdit: () => _showAddTodoDialog(
                                          context: context, existingItem: data),
                                      onDelete: () {
                                        ref
                                            .read(deleteTodoProvider)
                                            .call(data.id!)
                                            .then((_) {
                                          Future.delayed(
                                              Duration(milliseconds: 100), () {
                                            ref.invalidate(filterProvider);
                                          });
                                        });
                                      },
                                      onTap: () {
                                        final currentIndex =
                                            ref.read(expandedTaskIndexProvider);
                                        ref
                                                .read(expandedTaskIndexProvider
                                                    .notifier)
                                                .state =
                                            (currentIndex == index)
                                                ? -1
                                                : index;
                                      },
                                    );
                                  },
                                )
                              : const Center(
                                  child:
                                      Text('No hay tareas en esta categoría')),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, stack) =>
                              Center(child: Text('Error: $err')),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context: context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(
      {required BuildContext context, int? index, todoModel? existingItem}) {
    if (existingItem != null) {
      _titleController.text = existingItem.title;
    } else {
      _titleController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            existingItem == null ? "Agregar Tarea" : "Editar Tarea",
            style: TextStyle(color: Theme.of(context).canvasColor),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //TITULO
                CustomInputField(
                  controller: _titleController,
                  labelText: 'Tarea',
                  validatorMessage: 'Por favor ingrese la tarea',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {

                  final newItem = todoModel(
                    id: existingItem == null ? null : existingItem.id,
                    title: _titleController.text,
                    status: existingItem?.status ?? 0,
                  );

                  if (existingItem == null) {
                    await ref.read(insertTodoProvider).call(newItem);
                    ref.invalidate(filterProvider);
                  } else {
                    await ref.read(updateTodoProvider).call(newItem);
                    ref.invalidate(filterProvider);
                  }

                  Navigator.pop(context);
                }
              },
              child: Text(
                existingItem == null ? "Guardar" : "Actualizar",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
