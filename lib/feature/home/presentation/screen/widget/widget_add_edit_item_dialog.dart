import 'package:app_todo/feature/home/data/models/todoModel.dart';
import 'package:app_todo/feature/home/presentation/provider/filter_provider.dart';
import 'package:app_todo/feature/home/presentation/provider/provider_todo.dart';
import 'package:app_todo/feature/home/presentation/screen/widget/widget_customImputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItemDialog extends ConsumerStatefulWidget {
  //final int mainTableId;
  final todoModel? existingItem;
  final Function(todoModel)? onAddItem;

  const AddItemDialog(
      {Key? key, this.existingItem, this.onAddItem})
      : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends ConsumerState<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingItem?.title ?? "");
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      int position = 0;

    // Si es nueva tarea, buscamos la última posición
    if (widget.existingItem == null) {
      final existingTasks = await ref.read(getAllTodosProvider.future);

      if (existingTasks.isNotEmpty) {
        // Tomamos la posición más alta y sumamos 1
        final lastPosition = existingTasks.map((e) => e.position).reduce((a, b) => a > b ? a : b);
        position = lastPosition + 1;
      }
    } else {
      // Si se está editando una tarea, mantenemos su posición actual
      position = widget.existingItem!.position;
    }

      final newItem = todoModel(
        id: widget.existingItem == null ? null : widget.existingItem!.id,
        title: _titleController.text,
        status: widget.existingItem?.status ?? 0,
        position: position
      );

      if (widget.existingItem == null) {
        /*await ref.read(insertTodoProvider).call(newItem);
                    ref.invalidate(filterProvider);*/
        widget.onAddItem!(newItem);
        //_addTask(newItem);
      } else {
        ref.read(updateTodoProvider).call(newItem);
        ref.invalidate(filterProvider);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingItem == null ? 'Crear' : 'Editar',
          style: const TextStyle(fontFamily: 'Outfit')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Producto
            CustomInputField(
              controller: _titleController,
              labelText: 'tarea',
              validatorMessage: 'ingrese la tarea',
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancelar',
              style: const TextStyle(color: Colors.red, fontFamily: 'Outfit')),
        ),
        ElevatedButton(
          onPressed: _saveItem,
          child: Text(widget.existingItem == null ? 'guardar' : 'actualizar',
              style:
                  const TextStyle(color: Colors.black, fontFamily: 'Outfit')),
        ),
      ],
    );
  }
}
