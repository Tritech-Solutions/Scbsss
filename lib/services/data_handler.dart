// Importing necessary packages and files
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/mood_entry.dart';

// Class to handle database operations
class DatabaseHelper {
  // Database instance
  Database? _database;

  // Getter for the database instance
  Future<Database> get database async {
    // If the database instance exists, return it
    if (_database != null) return _database!;

    // If the database instance is null, initialize it
    _database = await initDatabase();
    return _database!;
  }

  // Function to initialize the database
  Future<Database> initDatabase() async {
    // Define the path for the database file
    String path = join(await getDatabasesPath(), 'mood_database.db');

    // Open or create the database
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the MoodEntry table if it doesn't exist
        await db.execute('''
          CREATE TABLE mood_entries(
            id INTEGER PRIMARY KEY,
            mood INTEGER,
            title TEXT,
            notes TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  // Function to insert a MoodEntry into the database
  Future<void> insertMoodEntry(MoodEntry entry) async {
    final Database db = await database;

    // Insert the MoodEntry into the correct table
    await db.insert(
      'mood_entries',
      entry.toMapDbString(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Function to retrieve all MoodEntries from the database
  Future<List<MoodEntry>> getAllMoodEntries() async {
    final Database db = await database;

    // Query the table for all MoodEntries
    final List<Map<String, dynamic>> maps = await db.query('mood_entries');

    // Convert the List<Map<String, dynamic>> to a List<MoodEntry>
    return List.generate(maps.length, (i) {
      return MoodEntry.fromMap(maps[i]);
    });
  }

  // Function to update a MoodEntry in the database
  Future<void> updateMoodEntry(MoodEntry entry) async {
    final Database db = await database;

    // Update the MoodEntry in the correct table
    await db.update(
      'mood_entries',
      entry.toMapDbString(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  // Function to delete a MoodEntry from the database
  Future<void> deleteMoodEntry(int id) async {
    final Database db = await database;

    // Delete the MoodEntry from the correct table
    await db.delete(
      'mood_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
