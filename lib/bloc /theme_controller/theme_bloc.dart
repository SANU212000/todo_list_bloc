import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define Theme Events (Actions that can be performed on the theme)
abstract class ThemeEvent {}

class LoadTheme extends ThemeEvent {} // Event to load the saved theme mode from SharedPreferences
class ToggleTheme extends ThemeEvent {} // Event to toggle between light and dark mode

// Define Theme States (Represents the UI state based on the event actions)
abstract class ThemeState {}

class ThemeInitial extends ThemeState {} // Initial state before loading theme

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode; // Stores the current theme mode (light, dark, or system)
  ThemeLoaded(this.themeMode);
}

// Bloc Implementation to manage theme state
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  // Constructor initializing with an initial state
  ThemeBloc() : super(ThemeInitial()) {
    // Handling LoadTheme event: Fetches and applies the saved theme
    on<LoadTheme>((event, emit) async {
      final themeMode = await _loadTheme(); // Retrieve saved theme from SharedPreferences
      emit(ThemeLoaded(themeMode)); // Emit the loaded theme mode
    });

    // Handling ToggleTheme event: Switches between light and dark themes
    on<ToggleTheme>((event, emit) async {
      final newTheme =
          (state is ThemeLoaded && (state as ThemeLoaded).themeMode == ThemeMode.dark)
              ? ThemeMode.light // If currently dark, switch to light
              : ThemeMode.dark; // Otherwise, switch to dark
      await _saveTheme(newTheme); // Save the selected theme in SharedPreferences
      emit(ThemeLoaded(newTheme)); // Emit the updated theme mode
    });
  }

  // Function to load the saved theme from SharedPreferences
  Future<ThemeMode> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    final savedTheme = prefs.getString('themeMode') ?? 'system'; // Retrieve saved theme or default to 'system'
    
    // Convert the saved theme string into a ThemeMode value
    return savedTheme == 'dark'
        ? ThemeMode.dark
        : savedTheme == 'light'
            ? ThemeMode.light
            : ThemeMode.system;
  }

  // Function to save the selected theme mode in SharedPreferences
  Future<void> _saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    await prefs.setString('themeMode', themeMode.toString().split('.').last); // Save theme as a string (light/dark/system)
  }
}
