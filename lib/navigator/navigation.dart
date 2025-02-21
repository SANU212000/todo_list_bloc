import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/controller/theme_controller/theme_bloc.dart';
import 'package:todo_list/controller/todo_bloc.dart';
import 'package:todo_list/controller/todo_events.dart';
import 'package:todo_list/navigator/navigatorBloc.dart';
import 'package:todo_list/screens/add_task.dart';
import 'package:todo_list/screens/intro.dart';
import 'package:todo_list/screens/todoscreen.dart';

// Global key for navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoBloc()..add(LoadTodos())),
        BlocProvider(create: (context) => ThemeBloc()..add(LoadTheme())),
        BlocProvider(create: (context) => NavigationBloc()),
      ],
      child: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          if (state is HomeNavigationState) {
            navigatorKey.currentState?.pushReplacementNamed('/home');
          } else if (state is AddTodoNavigationState) {
            navigatorKey.currentState?.pushNamed('/addTodo');
          }
        },
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Todo App',
              navigatorKey: navigatorKey, // Use the global key
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeState is ThemeLoaded
                  ? themeState.themeMode
                  : ThemeMode.system,
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              routes: {
                '/': (context) => const IntroScreen(),
                '/home': (context) => const TodoScreen(),
                '/addTodo': (context) => TaskListScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
