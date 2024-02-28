// Importing the necessary Dart packages
import 'dart:convert';

// Class representing a MoodEntry object
class MoodEntry {
  final int? id; // Unique identifier for each mood entry
  final int mood; // Mood rating from 1 to 5
  final String? title; // Optional title for the mood entry
  final String? notes; // Optional mood text
  final DateTime timestamp; // Timestamp for when the mood entry was created

  // Constructor for creating a MoodEntry object
  MoodEntry({
    this.id,
    required this.mood,
    this.title,
    this.notes,
    required this.timestamp,
  });

  // Function to convert MoodEntry object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'title': title,
      'notes': notes,
      'timestamp': timestamp,
    };
  }

  // Function to convert MoodEntry object to a map with timestamp as a string
  Map<String, dynamic> toMapDbString() {
    return {
      'id': id,
      'mood': mood,
      'title': title,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Factory method to create a MoodEntry object from a map
  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id']?.toInt() ?? 0,
      mood: map['mood'].toInt(),
      title: map['title'],
      notes: map['notes'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  // Function to convert MoodEntry object to a JSON string
  String toJson() => json.encode(toMap());

  // Factory method to create a MoodEntry object from a JSON string
  factory MoodEntry.fromJson(String source) =>
      MoodEntry.fromMap(json.decode(source));

  // Override toString method for better object representation
  @override
  String toString() {
    return 'MoodEntry(id: $id, mood: $mood, title: $title, notes: $notes, timestamp: $timestamp)';
  }

  // Function to create a copy of the MoodEntry with optional fields updated
  MoodEntry copyWith({
    int? id,
    int? mood,
    String? title,
    String? notes,
    DateTime? timestamp,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
