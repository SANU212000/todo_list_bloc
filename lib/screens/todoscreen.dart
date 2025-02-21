import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/controller/theme_controller/theme_bloc.dart';
import 'package:todo_list/controller/todo_bloc.dart';
import 'package:todo_list/controller/todo_events.dart';
import 'package:todo_list/controller/todo_state.dart';
import 'package:todo_list/funtions/todo_list.dart';
import 'package:todo_list/controller/constants.dart';
import 'package:todo_list/widgets/widgets.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
            icon: const Icon(Icons.brightness_6),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: FittedBox(
                child: Text(
                  'To-Do List',
                  style: TextStyle(
                    fontSize: 100,
                    fontFamily: "intro",
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                    wordSpacing: 2.0,
                    letterSpacing: 0.5,
                    height: 0.8,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 400,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 10,
                  shadowColor: kPrimaryColor,
                  surfaceTintColor: kWhiteColor,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 14),
                    child: BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state is TodoInitial) {
                          context.read<TodoBloc>().add(LoadTodos());

                          return ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return buildTaskTile(
                                  context,
                                  Todo(
                                    id: 'loading_$index',
                                    title: 'Loading...',
                                    isCompleted: false,
                                    color: Colors.grey[300]!,
                                  ),
                                  isLoading: true);
                            },
                          );
                        } else if (state is TodoLoaded) {
                          if (state.todos.isEmpty) {
                            return const Center(
                              child: Text(
                                'No tasks available. Add some!',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: state.todos.length,
                            itemBuilder: (context, index) {
                              final todo = state.todos[index];
                              return buildTaskTile(context, todo);
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, '/addTodo'),
                backgroundColor: kPrimaryColor,
                child: const Icon(Icons.add, size: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
