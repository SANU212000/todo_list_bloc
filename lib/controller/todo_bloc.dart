import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/controller/todo_state.dart';
import 'package:todo_list/controller/databasehelper.dart';
import 'package:todo_list/controller/todo_events.dart';
import 'package:todo_list/funtions/todo_list.dart';
import 'package:uuid/uuid.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  TodoBloc() : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<ToggleTodoStatus>(_onToggleTodoStatus);
    on<DeleteTodo>(_onDeleteTodo);
    on<UpdateTodo>(_onUpdateTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await _dbHelper.getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Failed to load todos: ${e.toString()}'));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final List<Color> colorList = [
        const Color.fromARGB(255, 175, 16, 5),
        const Color.fromARGB(255, 3, 67, 5),
        const Color.fromARGB(255, 10, 75, 128),
        const Color.fromARGB(255, 85, 11, 98),
        const Color.fromARGB(255, 11, 119, 83),
      ];

      final Color cardColor = colorList[Random().nextInt(colorList.length)];

      final newTodo = Todo(
        id: const Uuid().v4(),
        title: event.title,
        isCompleted: false,
        color: cardColor,
      );

      try {
        await _dbHelper.insertTodo(newTodo);
        final updatedTodos = List<Todo>.from((state as TodoLoaded).todos)..add(newTodo);
        emit(TodoLoaded(updatedTodos));
      } catch (e) {
        emit(TodoError('Failed to add todo: ${e.toString()}'));
      }
    }
  }

  Future<void> _onToggleTodoStatus(
      ToggleTodoStatus event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final updatedTodos = (state as TodoLoaded).todos.map((todo) {
        if (todo.id == event.id) {
          final updatedTodo = todo.copyWith(isCompleted: event.isCompleted);
          _dbHelper.updateTodo(updatedTodo);
          return updatedTodo;
        }
        return todo;
      }).toList();

      emit(TodoLoaded(updatedTodos));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      try {
        await _dbHelper.deleteTodo(event.id);
        final updatedTodos = (state as TodoLoaded)
            .todos
            .where((todo) => todo.id != event.id)
            .toList();
        emit(TodoLoaded(updatedTodos));
      } catch (e) {
        emit(TodoError('Failed to delete todo: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final updatedTodos = (state as TodoLoaded).todos.map((todo) {
        if (todo.id == event.updatedTodo.id) {
          _dbHelper.updateTodo(event.updatedTodo);
          return event.updatedTodo;
        }
        return todo;
      }).toList();

      emit(TodoLoaded(updatedTodos));
    }
  }
}
