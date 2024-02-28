// Importing necessary packages and files
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import '../services/data_handler.dart';

// Define a stateful widget for the "Edit Entry" screen
class EditEntryScreen extends StatefulWidget {
  final MoodEntry moodEntry;

  // Constructor to receive the mood entry to be edited
  EditEntryScreen({required this.moodEntry});

  @override
  _EditEntryScreenState createState() => _EditEntryScreenState();
}

// Define the state for the "Edit Entry" screen
class _EditEntryScreenState extends State<EditEntryScreen> {
  // Global key for the form to access form state
  final _formKey = GlobalKey<FormState>();

  // Controllers for handling input fields
  final _titleController = TextEditingController();
  final _entryController = TextEditingController();

  // Variable to store mood value and loading state
  double _currentMoodValue = 1;
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    // Set initial values for the input fields based on the provided mood entry
    _titleController.text = widget.moodEntry.title!;
    _entryController.text = widget.moodEntry.notes!;
  }

  // Build the UI for the "Edit Entry" screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Mood: ${_currentMoodValue.toInt()}'),
              Slider(
                value: _currentMoodValue,
                min: 1,
                max: 5,
                divisions: 4,
                label: _currentMoodValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentMoodValue = value;
                  });
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Generate a title based on the entry text
                    },
                    icon: const Icon(CupertinoIcons.sparkles),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: TextFormField(
                  maxLines: null,
                  controller: _entryController,
                  decoration: const InputDecoration(
                    labelText: 'Entry',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an entry';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Validate the form and update the entry if valid
                  if (_formKey.currentState?.validate() ?? false) {
                    _updateEntry();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to update the mood entry in the database
  void _updateEntry() {
    // Create a new MoodEntry object with the updated data
    MoodEntry updatedEntry = widget.moodEntry.copyWith(
      mood: _currentMoodValue.toInt(),
      title: _titleController.text,
      notes: _entryController.text,
      // Update other properties accordingly
    );

    // Call the DatabaseHelper to update the entry
    DatabaseHelper().updateMoodEntry(updatedEntry);

    // Show a success toast using CherryToast library
    CherryToast.success(
      title: Text("Updated", style: TextStyle(color: Colors.black)),
    ).show(context);

    // Close the edit screen and return to the previous screen
    Navigator.pop(context);
  }
}
