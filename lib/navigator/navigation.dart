import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc%20/bloc_controller/todo_bloc.dart';
import 'package:todo_list/bloc%20/bloc_controller/todo_events.dart';
import 'package:todo_list/bloc%20/theme_controller/theme_bloc.dart';
import 'package:todo_list/navigator/navigator_bloc.dart'; // Importing NavigationBloc for handling navigation state
import 'package:todo_list/screens/add_task.dart'; // Importing Add Task screen
import 'package:todo_list/screens/intro.dart'; // Importing Intro screen
import 'package:todo_list/screens/todoscreen.dart'; // Importing Todo screen

// Global key for navigator to manage navigation programmatically
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Global key for ScaffoldMessenger to show SnackBars globally
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Providing TodoBloc and triggering LoadTodos event to fetch tasks
        BlocProvider(create: (context) => TodoBloc()..add(LoadTodos())),
        
        // Providing ThemeBloc and triggering LoadTheme event to fetch the saved theme
        BlocProvider(create: (context) => ThemeBloc()..add(LoadTheme())),
        
        // Providing NavigationBloc for managing navigation state
        BlocProvider(create: (context) => NavigationBloc()),
      ],
      
      // Listening to NavigationBloc changes to handle screen navigation
      child: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          if (state is HomeNavigationState) {
            // Navigate to the home screen when HomeNavigationState is emitted
            navigatorKey.currentState?.pushReplacementNamed('/home');
          } else if (state is AddTodoNavigationState) {
            // Navigate to the add todo screen when AddTodoNavigationState is emitted
            navigatorKey.currentState?.pushNamed('/addTodo');
          }
        },

        // Listening to ThemeBloc to apply the selected theme
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              scaffoldMessengerKey: scaffoldMessengerKey, // Assigning global scaffold messenger key
              title: 'Todo App',
              navigatorKey: navigatorKey, // Assigning global navigator key
              
              // Defining light and dark themes
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              
              // Applying the current theme mode (light, dark, or system default)
              themeMode: themeState is ThemeLoaded
                  ? themeState.themeMode
                  : ThemeMode.system,
              
              debugShowCheckedModeBanner: false, // Hides debug banner
              
              initialRoute: '/', // Initial screen when app starts
              routes: {
                '/': (context) => const IntroScreen(), // Intro screen
                '/home': (context) => const TodoScreen(), // Home screen (Todo list)
                '/addTodo': (context) => TaskListScreen(), // Add Task screen
              },
            );
          },
        ),
      ),
    );
  }
}
