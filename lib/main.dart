import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/navigator/navigation.dart';
import 'package:todo_list/navigator/navigatorBloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => NavigationBloc(),
      child: const TodoApp(),
    ),
  );
}
