import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'; // Importing custom Snackbar package
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/screens/constants.dart'; // Importing constants for colors and styles
import 'package:todo_list/bloc%20/bloc_controller/todo_bloc.dart'; // Importing TodoBloc for state management
import 'package:todo_list/bloc%20/bloc_controller/todo_events.dart'; // Importing events for TodoBloc

// TaskListScreen - Screen for adding a new task
class TaskListScreen extends StatelessWidget {
  // TextEditingController to manage user input
  final TextEditingController _textController = TextEditingController();

  TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disables default back button
        toolbarHeight: 80, // Sets custom height for AppBar
        backgroundColor: kPrimaryColor, // Uses primary color from constants
        elevation: 0, // Removes shadow
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0)), // Rounded bottom corners
        ),
        flexibleSpace: Center(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color:
                  Color.fromRGBO(0, 0, 0, 0.1), // Light transparent background
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // Soft shadow
                  blurRadius: 2,
                  offset: Offset(-0, -0),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: kWhiteColor), // Custom back button icon
              onPressed: () {
                Navigator.of(context).pop(); // Navigate back
              },
            ),
          ),
        ),
        centerTitle: true,
      ),

      // Main body container
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 45.0, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors
                          .grey[200], // Light grey background for input field
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft:
                              Radius.circular(10)), // Rounded left corners
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller:
                          _textController, // Connects text field to controller
                      decoration: const InputDecoration(
                        border: InputBorder.none, // Removes default border
                        hintText: 'Enter a task', // Placeholder text
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 1),

                // Add Task Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), // Circular button
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      // Dispatches AddTodo event with entered text
                      context
                          .read<TodoBloc>()
                          .add(AddTodo(_textController.text));

                      // Snackbar notification
                      const snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        content: AwesomeSnackbarContent(
                          title: 'Success!',
                          message: 'New task added successfully!',
                          contentType:
                              ContentType.success, // Success-themed snackbar
                        ),
                      );

                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar); // Show snackbar

                      _textController
                          .clear(); // Clear input field after adding task
                    }
                  },
                  child: const Icon(
                    Icons.add,
                    color: kPrimaryColor, // Uses primary color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
