# Setting Up and Running the Flutter Todo App

## Prerequisites
Before setting up the project, ensure you have the following installed:
- **Flutter SDK** (Latest stable version) – [Download here](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (Comes with Flutter)
- **Android Studio** (For Android development) or **Xcode** (For iOS development)
- **VS Code** or **Android Studio** (Recommended IDEs)
- **Emulator/Physical Device** (Android or iOS)
- **Dependencies:** Ensure `flutter_bloc`, `sqflite`, `shared_preferences`, and `uuid` are installed.

---

## Project Setup

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/your-repo/todo-list.git
   cd todo-list
   ```

2. **Install Dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the Project:**
   ```sh
   flutter run
   ```

4. **Build for Release (Optional):**
   ```sh
   flutter build apk   # For Android
   flutter build ios   # For iOS
   ```

---

## Project Structure

```
/todo_list
│-- lib
│   ├── main.dart                 # Entry point of the application
│   ├── model
│   │   ├── todo_list.dart         # Model class for Todo items
│   ├── repository
│   │   ├── database_helper.dart   # Manages SQLite database operations
│   ├── bloc_controller
│   │   ├── bloc
│   │   │   ├── todo_bloc.dart     # Handles business logic for todos
│   │   │   ├── todo_events.dart   # Defines events for todo operations
│   │   │   ├── todo_state.dart    # Defines states for todo operations
│   ├── theme
│   │   ├── theme_bloc.dart        # Manages theme state (light/dark mode)
│   ├── screens
│   │   ├── home_screen.dart       # Main UI displaying todo list
│   │   ├── add_todo_screen.dart  # UI to add new todos
│   │   ├── introscreen .dart
│   ├── widgets
│   │   ├── todo_item.dart         # Reusable widget for displaying a todo item
│-- pubspec.yaml                   # Project dependencies and assets
```

---

## Functionality Breakdown

### **1. Todo List Management**
- Uses **SQLite** (`sqflite` package) for persistent data storage.
- Uses **Flutter BLoC** for state management.
- Provides operations: **Add, Update, Delete, Toggle Completion Status**.

### **2. Theming with SharedPreferences**
- Supports **Dark Mode** and **Light Mode**.
- Saves user preference using `shared_preferences`.

### **3. Business Logic Implementation**
- `TodoBloc` handles fetching, adding, updating, and deleting todos.
- `ThemeBloc` manages theme mode toggling.

---

## How It Works
1. **App Launches:**
   - Loads theme preference (`LoadTheme` event in `ThemeBloc`).
   - Loads existing todos from SQLite (`LoadTodos` event in `TodoBloc`).

2. **User Interactions:**
   - Adding a todo triggers `AddTodo` event and updates the database.
   - Updating a todo modifies the existing entry in the database.
   - Deleting a todo removes it from the database.
   - Marking a todo as complete/incomplete updates its status.
   - Theme switching persists the user's selection.

---

## Conclusion
This Flutter Todo App efficiently manages tasks with **BLoC state management**, **SQLite storage**, and **persistent theming**. The structured architecture ensures scalability and maintainability for future enhancements.

