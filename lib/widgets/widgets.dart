import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todo_list/controller/todo_bloc.dart';
import 'package:todo_list/controller/todo_events.dart';
import 'package:todo_list/controller/todo_state.dart';
import 'package:todo_list/funtions/todo_list.dart';

Widget buildTaskTile(BuildContext context, Todo todo,
      {bool isLoading = false}) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart, // Swipe from right to left
      background: Container(
        color: Colors.red, // Red background for delete action
        padding: const EdgeInsets.only(right: 16),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Task"),
              content: const Text("Are you sure you want to delete this task?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child:
                      const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<TodoBloc>().add(DeleteTodo(todo.id)); // Remove from Bloc
        final snackBar = SnackBar(
          elevation: 1,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Task Deleted',
            message: "'${todo.title}' has been removed successfully!",
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isLoading
              ? Colors.grey[300]
              : (todo.isCompleted ? Colors.grey[400] : todo.color),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          title: isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 18,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                )
              : Text(
                  todo.title,
                  style: TextStyle(
                    fontFamily: "intro",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: todo.isCompleted ? Colors.black : Colors.white,
                  ),
                ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isLoading) // Hide button if loading
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () =>
                      showUpdateDialog(context, todo.id, todo.title),
                ),
              Checkbox(
                value: isLoading ? false : todo.isCompleted,
                onChanged: isLoading
                    ? null
                    : (bool? value) {
                        if (value != null) {
                          context
                              .read<TodoBloc>()
                              .add(ToggleTodoStatus(todo.id, value));
                        }
                      },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                activeColor: Colors.white,
                checkColor: Colors.black,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showUpdateDialog(BuildContext context, String id, String currentTitle) {
    final TextEditingController updateController =
        TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Task'),
        content: TextField(
          controller: updateController,
          decoration: const InputDecoration(labelText: 'Update the task'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (updateController.text.isNotEmpty) {
                final currentState = context.read<TodoBloc>().state;
                if (currentState is TodoLoaded) {
                  final existingTodo = currentState.todos.firstWhere(
                    (t) => t.id == id,
                    orElse: () => Todo(
                        id: '',
                        title: '',
                        isCompleted: false,
                        color: Colors.white),
                  );

                  if (existingTodo != null) {
                    final updatedTodo =
                        existingTodo.copyWith(title: updateController.text);
                    context.read<TodoBloc>().add(UpdateTodo(updatedTodo));
                    Navigator.pop(context);
                  }
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
