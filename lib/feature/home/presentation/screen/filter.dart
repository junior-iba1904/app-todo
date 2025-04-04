import 'package:app_todo/feature/home/presentation/provider/filter_provider.dart';
import 'package:app_todo/feature/home/presentation/screen/widget/widget_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

class Filter extends StatelessWidget {
  const Filter({super.key});

  @override
  Widget build(BuildContext context) {
    final filter = ['Pendientes', 'Completas'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtro'),
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
                                    mode: 2,
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
          ))
    );
  }
  
}
