import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NavigateToHome extends NavigationEvent {}

class NavigateToAddTodo extends NavigationEvent {}

abstract class NavigationState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialNavigationState extends NavigationState {}

class HomeNavigationState extends NavigationState {}

class AddTodoNavigationState extends NavigationState {}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(InitialNavigationState()) {
    on<NavigateToHome>((event, emit) {
      print("Navigating to Home");
      emit(HomeNavigationState());
    });

    on<NavigateToAddTodo>((event, emit) {
      print("Navigating to Add Todo");
      emit(AddTodoNavigationState());
    });
  }
}
