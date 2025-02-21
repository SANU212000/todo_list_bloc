import 'package:flutter_bloc/flutter_bloc.dart'; // Importing flutter_bloc package for state management
import 'package:equatable/equatable.dart'; // Importing equatable for value-based equality comparison

// Abstract class representing navigation events
abstract class NavigationEvent extends Equatable {
  @override
  List<Object> get props => []; // Ensuring all events are comparable
}

// Event to navigate to the Home screen
class NavigateToHome extends NavigationEvent {}

// Event to navigate to the Add Todo screen
class NavigateToAddTodo extends NavigationEvent {}

// Abstract class representing navigation states
abstract class NavigationState extends Equatable {
  @override
  List<Object> get props => []; // Ensuring all states are comparable
}

// Initial state when the app starts
class InitialNavigationState extends NavigationState {}

// State representing navigation to the Home screen
class HomeNavigationState extends NavigationState {}

// State representing navigation to the Add Todo screen
class AddTodoNavigationState extends NavigationState {}

// NavigationBloc class that handles navigation state changes
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  // Initial state is set to InitialNavigationState
  NavigationBloc() : super(InitialNavigationState()) {
    
    // Handling navigation to Home
    on<NavigateToHome>((event, emit) {
      // ignore: avoid_print
      print("Navigating to Home");
      emit(HomeNavigationState()); // Emitting HomeNavigationState
    });

    // Handling navigation to Add Todo screen
    on<NavigateToAddTodo>((event, emit) {
      // ignore: avoid_print
      print("Navigating to Add Todo");
      emit(AddTodoNavigationState()); // Emitting AddTodoNavigationState
    });
  }
}
