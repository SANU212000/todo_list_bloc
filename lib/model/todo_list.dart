import 'package:flutter/material.dart';

class Todo {
  final String id;
  final String title;
  final bool isCompleted;
  final Color color;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.color,
  });

  // ✅ Add `copyWith` method
  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    Color? color,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
    );
  }

  // ✅ Convert Todo to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
      'color': color.toARGB32(),
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
      color: Color(map['color']),
    );
  }
}
  