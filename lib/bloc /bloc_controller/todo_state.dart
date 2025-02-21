import 'package:flutter/material.dart';
import 'package:todo_list/model/todo_list.dart';

@immutable // Ensures that state objects are immutable
abstract class TodoState {} // Abstract base class for all todo states

// Represents the initial state of the application (before any data is loaded)
class TodoInitial extends TodoState {}

// Represents a loading state (e.g., when fetching data from a database or API)
class TodoLoading extends TodoState {}

// Represents the state when todos are successfully loaded
class TodoLoaded extends TodoState {
  final List<Todo> todos; // List of todos

  TodoLoaded(this.todos); // Constructor to initialize the todos list
}

// Represents an error state (e.g., when fetching todos fails)
class TodoError extends TodoState {
  final String message; // Error message

  TodoError(this.message); // Constructor to initialize the error message
}
