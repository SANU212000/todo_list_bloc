import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define Theme Events
abstract class ThemeEvent {}

class LoadTheme extends ThemeEvent {} 
class ToggleTheme extends ThemeEvent {}

// Define Theme States
abstract class ThemeState {}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;
  ThemeLoaded(this.themeMode);
}

// Bloc Implementation
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<LoadTheme>((event, emit) async {
      final themeMode = await _loadTheme();
      emit(ThemeLoaded(themeMode));
    });

    on<ToggleTheme>((event, emit) async {
      final newTheme =
          (state is ThemeLoaded && (state as ThemeLoaded).themeMode == ThemeMode.dark)
              ? ThemeMode.light
              : ThemeMode.dark;
      await _saveTheme(newTheme);
      emit(ThemeLoaded(newTheme));
    });
  }

  Future<ThemeMode> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('themeMode') ?? 'system';
    return savedTheme == 'dark'
        ? ThemeMode.dark
        : savedTheme == 'light'
            ? ThemeMode.light
            : ThemeMode.system;
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode.toString().split('.').last);
  }
}
