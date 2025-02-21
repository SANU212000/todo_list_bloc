import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/bloc%20/bloc_controller/todo_state.dart';
import 'package:todo_list/repostiory/databasehelper.dart';
import 'package:todo_list/bloc%20/bloc_controller/todo_events.dart';
import 'package:todo_list/model/todo_list.dart';
import 'package:uuid/uuid.dart';

// The Bloc class that manages todo-related state and handles different events
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final DatabaseHelper _dbHelper =
      DatabaseHelper(); // Database helper for CRUD operations

  // Constructor: Initializes with TodoInitial state and registers event handlers
  TodoBloc() : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos); // Handles loading todos
    on<AddTodo>(_onAddTodo); // Handles adding a new todo
    on<ToggleTodoStatus>(
        _onToggleTodoStatus); // Handles toggling the completion status of a todo
    on<DeleteTodo>(_onDeleteTodo); // Handles deleting a todo
    on<UpdateTodo>(_onUpdateTodo); // Handles updating a todo
  }

  // Event handler for loading todos from the database
  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading()); // Emit loading state while fetching data
    try {
      final todos = await _dbHelper.getTodos(); // Fetch todos from the database
      emit(TodoLoaded(todos)); // Emit loaded state with todos
    } catch (e) {
      emit(TodoError(
          'Failed to load todos: ${e.toString()}')); // Emit error state on failure
    }
  }

  // Event handler for adding a new todo
  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      // Define a list of colors for todo items
      final List<Color> colorList = [
        const Color.fromARGB(255, 175, 16, 5),
        const Color.fromARGB(255, 3, 67, 5),
        const Color.fromARGB(255, 10, 75, 128),
        const Color.fromARGB(255, 85, 11, 98),
        const Color.fromARGB(255, 11, 119, 83),
      ];

      // Randomly select a color for the new todo item
      final Color cardColor = colorList[Random().nextInt(colorList.length)];

      // Create a new Todo object
      final newTodo = Todo(
        id: const Uuid().v4(), // Generate a unique ID
        title: event.title, // Assign the title from the event
        isCompleted: false, // Default to not completed
        color: cardColor, // Assign a random color
      );

      try {
        await _dbHelper.insertTodo(newTodo); // Insert into the database
        final updatedTodos = List<Todo>.from((state as TodoLoaded).todos)
          ..add(newTodo); // Update the todo list
        emit(TodoLoaded(updatedTodos)); // Emit updated todo list
      } catch (e) {
        emit(TodoError(
            'Failed to add todo: ${e.toString()}')); // Emit error state on failure
      }
    }
  }

  // Event handler for toggling the completion status of a todo
  Future<void> _onToggleTodoStatus(
      ToggleTodoStatus event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final updatedTodos = (state as TodoLoaded).todos.map((todo) {
        if (todo.id == event.id) {
          final updatedTodo = todo.copyWith(
              isCompleted: event.isCompleted); // Create updated todo
          _dbHelper.updateTodo(updatedTodo); // Update the todo in the database
          return updatedTodo;
        }
        return todo;
      }).toList();

      emit(TodoLoaded(updatedTodos)); // Emit updated todo list
    }
  }

  // Event handler for deleting a todo
  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      try {
        await _dbHelper
            .deleteTodo(event.id); // Delete the todo from the database
        final updatedTodos = (state as TodoLoaded)
            .todos
            .where((todo) =>
                todo.id != event.id) // Remove the deleted todo from the list
            .toList();
        emit(TodoLoaded(updatedTodos)); // Emit updated todo list
      } catch (e) {
        emit(TodoError(
            'Failed to delete todo: ${e.toString()}')); // Emit error state on failure
      }
    }
  }

  // Event handler for updating a todo
  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final updatedTodos = (state as TodoLoaded).todos.map((todo) {
        if (todo.id == event.updatedTodo.id) {
          _dbHelper
              .updateTodo(event.updatedTodo); // Update the todo in the database
          return event.updatedTodo;
        }
        return todo;
      }).toList();

      emit(TodoLoaded(updatedTodos)); // Emit updated todo list
    }
  }
}
