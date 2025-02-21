import 'package:todo_list/model/todo_list.dart'; // Importing the Todo model

// Defining an abstract base class for all Todo events
abstract class TodoEvent {}

// Event to load all todos (usually triggered at the app start or refresh)
class LoadTodos extends TodoEvent {}

// Event to add a new todo item
class AddTodo extends TodoEvent {
  final String title; // Title of the new todo
  
  AddTodo(this.title); // Constructor to initialize the title
}

// Event to toggle the completion status of a todo item
class ToggleTodoStatus extends TodoEvent {
  final String id; // Unique ID of the todo item
  final bool isCompleted; // New completion status (true or false)
  
  ToggleTodoStatus(this.id, this.isCompleted); // Constructor to initialize fields
}

// Event to update an existing todo item
class UpdateTodo extends TodoEvent {
  final Todo updatedTodo; // The updated todo object
  
  UpdateTodo(this.updatedTodo); // Constructor to initialize the updated todo
}

// Event to delete a todo item
class DeleteTodo extends TodoEvent {
  final String id; // Unique ID of the todo to be deleted
  
  DeleteTodo(this.id); // Constructor to initialize the ID
}
