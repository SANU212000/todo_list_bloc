
import 'package:todo_list/funtions/todo_list.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);
}

class ToggleTodoStatus extends TodoEvent {
  final String id;
  final bool isCompleted;
  ToggleTodoStatus(this.id, this.isCompleted);
}

class UpdateTodo extends TodoEvent {
  final Todo updatedTodo;

  UpdateTodo(this.updatedTodo); // ✅ Remove unnecessary text parameter
}

class DeleteTodo extends TodoEvent {
  final String id;
  DeleteTodo(this.id);
}
