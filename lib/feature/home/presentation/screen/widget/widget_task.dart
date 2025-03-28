import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/presentation/provider/filter_provider.dart';
import 'package:app_todo/feature/home/presentation/provider/provider_todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskItem extends ConsumerStatefulWidget {
  final todoModel data;
  final bool isExpanded;
  final void Function() onEdit;
  final void Function() onDelete;
  final void Function() onTap;

  const TaskItem({
    super.key,
    required this.data,
    required this.isExpanded,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

void _handleDelete() {
  _controller.reverse().then((_) {
    widget.onDelete();
    Future.delayed(Duration(milliseconds: 100), () {
      ref.invalidate(filterProvider);
    });
  });
}




    @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        margin: const EdgeInsets.all(
                  8.0),
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
                value: widget.data.status == 1,
                onChanged: (value) async {
                  int newStatus = value == true ? 1 : 0;
                  await ref
                      .read(updateTodoStatusProvider)
                      .call(widget.data.id!, newStatus);
                  ref.invalidate(filterProvider);
                },
              ),
              title: Text(widget.data.title, overflow: TextOverflow.ellipsis, maxLines: 1),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: widget.onEdit,
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: _handleDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              onTap: widget.onTap,
            ),
            if (widget.isExpanded)
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
                    Text(widget.data.title,
                        style: const TextStyle(fontSize: 16, color: Colors.black)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
