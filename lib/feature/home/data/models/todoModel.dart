

import 'package:app_todo/feature/home/domain/entities/todo_entities.dart';

class todoModel extends Todo{
  todoModel({
    super.id,
    required super.title,
    required super.status,

  });

  factory todoModel.fromJson(Map<String, dynamic> json) {
    return todoModel(
      id: json['id'],
      title: json['title'],
      status: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'estado': status,
    };
  }
}