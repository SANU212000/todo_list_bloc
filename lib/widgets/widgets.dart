import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // ✅ For loading effect
import 'package:todo_list/bloc%20/bloc_controller/todo_bloc.dart'; // ✅ BLoC for task management
import 'package:todo_list/bloc%20/bloc_controller/todo_events.dart';
import 'package:todo_list/bloc%20/bloc_controller/todo_state.dart';
import 'package:todo_list/model/todo_list.dart'; // ✅ Task model
import 'package:flutter_slidable/flutter_slidable.dart'; // ✅ Swipe actions
import 'package:todo_list/navigator/navigation.dart'; // ✅ Navigation management

/// ✅ Builds an individual task tile
Widget buildTaskTile(BuildContext context, Todo todo,
    {bool isLoading = false}) {
  return Slidable(
    // ✅ Enables swipe actions on each task
    key: Key(todo.id), // ✅ Unique key for each task
    endActionPane: ActionPane(
      // ✅ Defines actions when swiping from right
      motion: const BehindMotion(), // ✅ Smooth slide animation
      children: [
        SlidableAction(
          // 🚀 Delete action
          onPressed: (context) async {
            final todoBloc =
                context.read<TodoBloc>(); // ✅ Access the BLoC instance

            // ✅ Show confirmation dialog before deleting
            bool? confirmDelete = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Delete Task"),
                  content:
                      const Text("Are you sure you want to delete this task?"),
                  actions: [
                    TextButton(
                      // ❌ Cancel button
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      // ✅ Confirm delete button
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Delete",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );

            // ✅ Delete task if confirmed
            if (confirmDelete == true) {
              todoBloc.add(DeleteTodo(todo.id)); // 🚀 Dispatch delete event
              scaffoldMessengerKey.currentState?.showSnackBar(
                // ✅ Show snackbar
                SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Task Deleted',
                    message: "'${todo.title}' has been removed successfully!",
                    contentType: ContentType.failure,
                  ),
                ),
              );
            }
          },
          backgroundColor: Colors.red, // 🎨 Delete button color
          foregroundColor: Colors.white, // 🎨 Icon color
          icon: Icons.delete, // 🗑️ Delete icon
          label: 'Delete',
          borderRadius: BorderRadius.circular(16), // 🎨 Rounded corners
        ),
      ],
    ),

    // ✅ Main container for the task tile
    child: Container(
      height: 130, // 📏 Tile height
      margin:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // 🎨 Spacing
      decoration: BoxDecoration(
        color: isLoading
            ? Colors.grey[300] // 🎨 Grey when loading
            : (todo.isCompleted
                ? Colors.grey
                : todo.color), // ✅ Use task color if available
        borderRadius: BorderRadius.circular(16), // 🎨 Rounded edges
        boxShadow: const [
          BoxShadow(
            // 🎨 Adds shadow effect
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(-1, -12),
          ),
        ],
      ),
      child: ListTile(
        // ✅ Task details inside the tile
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        // ✅ Title text (animated shimmer when loading)
        title: isLoading
            ? Shimmer.fromColors(
                // 🎨 Loading effect
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 18,
                  width: double.infinity,
                  color: Colors.white,
                ),
              )
            : Text(
                todo.title, // ✅ Show task title
                style: TextStyle(
                  fontFamily: "intro",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: todo.isCompleted
                      ? Colors.black
                      : Colors.white, // 🎨 Change color if completed
                ),
              ),

        // ✅ Action buttons (Edit and Checkbox)
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // ✅ Ensures row takes minimal space
          children: [
            if (!isLoading) // ✅ Show edit button only when not loading
              IconButton(
                icon: const Icon(Icons.edit,
                    color: Colors.white), // 🖊️ Edit icon
                onPressed: () => showUpdateDialog(
                    context, todo.id, todo.title), // ✅ Show edit dialog
              ),
            Transform.scale(
              // ✅ Enlarges checkbox
              scale: 2,
              child: Checkbox(
                value: isLoading
                    ? false
                    : todo.isCompleted, // ✅ Shows task completion state
                onChanged: isLoading
                    ? null
                    : (bool? value) {
                        if (value != null) {
                          context.read<TodoBloc>().add(ToggleTodoStatus(
                              todo.id, value)); // 🚀 Toggle task status
                        }
                      },
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(6.0)), // 🎨 Rounded checkbox
                activeColor: Colors.white, // ✅ Checkbox color
                checkColor: Colors.black, // ✅ Tick mark color
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// ✅ Shows a dialog to update task title
void showUpdateDialog(BuildContext context, String id, String currentTitle) {
  final TextEditingController updateController = TextEditingController(
      text: currentTitle); // 📝 Pre-fill with current title

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Update Task'),
      content: TextField(
        controller: updateController, // ✅ Input field for new title
        decoration: const InputDecoration(labelText: 'Update the task'),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context), // ❌ Close dialog without saving
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (updateController.text.isNotEmpty) {
              // ✅ Ensure input is not empty
              final currentState = context.read<TodoBloc>().state;

              if (currentState is TodoLoaded) {
                // ✅ Check if tasks are loaded
                final existingTodo = currentState.todos.firstWhere(
                  (t) => t.id == id,
                  orElse: () => Todo(
                    id: '',
                    title: '',
                    isCompleted: false,
                    color: Colors.white,
                  ),
                );

                final updatedTodo = existingTodo.copyWith(
                    title: updateController.text); // ✅ Update task
                context
                    .read<TodoBloc>()
                    .add(UpdateTodo(updatedTodo)); // 🚀 Dispatch update event
                Navigator.pop(context); // ✅ Close dialog
              }
            }
          },
          child: const Text('Update'),
        ),
      ],
    ),
  );
}
