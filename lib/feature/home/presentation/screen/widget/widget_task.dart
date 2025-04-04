import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/presentation/provider/filter_provider.dart';
import 'package:app_todo/feature/home/presentation/provider/provider_todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskItem extends ConsumerWidget {
  final todoModel data;
  final bool? isExpanded;
  final void Function()? onEdit;
  final void Function()? onDelete;
  final void Function()? onTap;
  final int? mode;

  const TaskItem({
    super.key,
    required this.data,
    this.isExpanded,
    this.onEdit,
    this.onDelete,
    this.onTap,
    this.mode
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).indicatorColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 5.0,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              activeColor: Colors.amber,
              checkColor: Colors.white,
              value: data.status == 1,
              onChanged: (value) async {
                int newStatus = value == true ? 1 : 0;
                await ref
                    .read(updateTodoStatusProvider)
                    .call(data.id!, newStatus);
                ref.invalidate(filterProvider);
              },
            ),
            title: Text(data.title,
                overflow: TextOverflow.ellipsis, maxLines: 1),
            trailing: mode == 1
            ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ) : null,
            onTap: onTap,
          ),
          if (isExpanded ?? false)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
