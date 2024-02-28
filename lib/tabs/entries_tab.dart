// Importing necessary packages and files
import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:scbsss/models/mood_entry.dart';
import '../services/data_handler.dart';
import 'edit_scree.dart';

// Define a stateful widget for the "Entries" tab
class EntriesTab extends StatefulWidget {
  @override
  State<EntriesTab> createState() => _EntriesTabState();
}

// Define the state for the "Entries" tab
class _EntriesTabState extends State<EntriesTab> {
  // Stream controller to manage mood entries stream
  late StreamController<List<MoodEntry>> _streamController;

  // Future to hold the mood entries fetched from the database
  late Future<List<MoodEntry>> futureMoodEntries;

  @override
  void initState() {
    super.initState();
    // Initialize stream controller
    _streamController = StreamController<List<MoodEntry>>.broadcast();
    // Fetch mood entries from the database
    futureMoodEntries = fetchMoodEntries();
  }

  @override
  void dispose() {
    // Close the stream controller when the widget is disposed
    _streamController.close();
    super.dispose();
  }

  // Function to fetch mood entries from the database
  Future<List<MoodEntry>> fetchMoodEntries() async {
    // Retrieve mood entries from the database
    List<MoodEntry> entries = await DatabaseHelper().getAllMoodEntries();
    // Add the entries to the stream
    _streamController.add(entries);
    // Return the entries
    return entries;
  }

  // Build the UI for the "Entries" tab
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entries'),
      ),
      body: StreamBuilder<List<MoodEntry>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display loading indicator while waiting for data
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (!snapshot.hasData) {
            // Display message when no data is available
            return Center(
              child: Text(
                "No Entry Added!!!",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // Display error message if an error occurs
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.isEmpty) {
            // Display message when no entries are available
            return Center(
              child: Text(
                "No Entry Added!!!",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            );
          } else {
            // Display a list of mood entries
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                MoodEntry entry = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                    Colors.black.withOpacity(0.5),
                                    child: Text(
                                      entry.mood.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      entry.title.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // TODO: Implement edit functionality
                                _editEntry(entry);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                  Icons.delete, color: Colors.red),
                              onPressed: () {
                                // TODO: Implement delete functionality
                                _deleteEntry(entry);
                              },
                            ),
                          ],
                        ),
                        Text(
                          entry.notes.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to handle the deletion of a mood entry
  void _deleteEntry(MoodEntry entry) async {
    // Display a confirmation dialog
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this entry?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Not confirmed
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmed
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    // If the deletion is confirmed, delete the entry from the database
    if (confirmed == true) {
      await DatabaseHelper().deleteMoodEntry(entry.id!);

      // Update the UI with the latest mood entries
      setState(() {
        futureMoodEntries = fetchMoodEntries();
      });

      // Show a deletion toast using CherryToast library
      CherryToast.error(
          title: Text("Deleted", style: TextStyle(color: Colors.black)))
          .show(context);
    }
  }

  // Function to handle the editing of a mood entry
  void _editEntry(MoodEntry entry) async {
    // Navigate to the EditEntryScreen and receive the updated mood entry
    MoodEntry updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEntryScreen(moodEntry: entry),
      ),
    );

    // If the updated entry is not null, update the UI with the latest mood entries
    if (updatedEntry != null) {
      setState(() {
        futureMoodEntries = fetchMoodEntries();
      });

      // Show an update toast using CherryToast library
      CherryToast.success(
          title: Text("Updated", style: TextStyle(color: Colors.black)))
          .show(context);
    }
  }
}
