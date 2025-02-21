import 'package:sqflite/sqflite.dart'; // Importing sqflite for database operations
import 'package:path/path.dart'; // Importing path to handle database path creation
import 'package:todo_list/model/todo_list.dart'; // Importing the Todo model

// Singleton class to manage the SQLite database
class DatabaseHelper {
  // Creating a single instance of DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Database instance variable
  static Database? _database;

  // Factory constructor to return the same instance
  factory DatabaseHelper() => _instance;

  // Private named constructor for singleton pattern
  DatabaseHelper._internal();

  // Getter to retrieve the database instance
  Future<Database> get database async {
    // If the database already exists, return it
    if (_database != null) return _database!;
    
    // Otherwise, initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  // Method to initialize the SQLite database
  Future<Database> _initDatabase() async {
    // Getting the path for the database file
    final path = join(await getDatabasesPath(), 'todo_list.db');
    
    // Opening the database and creating the table if it doesn’t exist
    return await openDatabase(
      path,
      version: 1, // Database version (used for migrations)
      onCreate: (db, version) async {
        // Creating the 'todos' table with necessary columns
        await db.execute('''
          CREATE TABLE todos (
            id TEXT PRIMARY KEY,       -- Unique identifier for each todo
            title TEXT NOT NULL,       -- Title of the todo
            isCompleted INTEGER NOT NULL, -- 1 for completed, 0 for not completed
            color INTEGER NOT NULL     -- Storing color as an integer
          )
        ''');
      },
    );
  }

  // Method to insert a new todo item into the database
  Future<void> insertTodo(Todo todo) async {
    final db = await database; // Getting the database instance
    
    // Inserting the todo into the 'todos' table
    await db.insert(
      'todos',
      todo.toMap(), // Converting the todo object to a Map
      conflictAlgorithm: ConflictAlgorithm.replace, // Replaces existing entry if ID matches
    );
  }

  // Method to retrieve all todo items from the database
  Future<List<Todo>> getTodos() async {
    final db = await database; // Getting the database instance
    
    // Querying all rows from the 'todos' table
    final List<Map<String, dynamic>> maps = await db.query('todos');

    // Converting the list of maps to a list of Todo objects
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  // Method to update an existing todo item
  Future<void> updateTodo(Todo todo) async {
    final db = await database; // Getting the database instance
    
    // Updating the row where the ID matches
    await db.update(
      'todos',
      todo.toMap(), // Converting the updated todo object to a Map
      where: 'id = ?',
      whereArgs: [todo.id], // Matching the ID to update the correct row
    );
  }

  // Method to delete a todo item from the database
  Future<void> deleteTodo(String id) async {
    final db = await database; // Getting the database instance
    
    // Deleting the row where the ID matches
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id], // Matching the ID to delete the correct row
    );
  }
}
