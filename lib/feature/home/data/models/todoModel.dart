

import 'package:app_todo/feature/home/domain/entities/todo_entities.dart';

class todoModel extends Todo{
  todoModel({
    super.id,
    required super.title,
    required super.status,
    required super.position

  });

  factory todoModel.fromJson(Map<String, dynamic> json) {
    return todoModel(
      id: json['id'],
      title: json['title'],
      status: json['estado'],
      position: json['position']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'estado': status,
      'position': position
    };
  }

  todoModel copyWith({
    int? id,
    String? title,
    int? status,
  }) {
    return todoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      position: position ?? this.position
    );
  }
}