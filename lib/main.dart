import 'package:flutter/material.dart';  // Importing Flutter's material design package
import 'package:flutter_bloc/flutter_bloc.dart';  // Importing flutter_bloc for state management
import 'package:todo_list/navigator/navigation.dart';  // Importing the navigation file
import 'package:todo_list/navigator/navigator_bloc.dart';  // Importing the Bloc for navigation control

void main() {
  // The entry point of the Flutter application
  runApp(
    BlocProvider(
      create: (context) => NavigationBloc(),  // Providing the NavigationBloc to manage navigation state
      child: const TodoApp(),  // Running the main application widget
    ),
  );
}
