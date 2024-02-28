// Importing necessary Flutter packages and files
import 'package:flutter/material.dart';
import 'package:scbsss/main_tab_widget.dart';
import 'package:scbsss/setup_wizard.dart';
import 'package:scbsss/services/database_service.dart';

// Main function to run the application
void main() {
  runApp(const MyApp());
}

// Root application widget
class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// State class for the application widget
class _MyAppState extends State<MyApp> {
  bool isSetupDone = false; // Variable to track if the setup is completed
  bool isLoading = true; // Variable to track loading state

  // Callback function to mark the setup as complete
  void completeSetup() {
    setState(() {
      isSetupDone = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase(); // Initialize the database when the app starts
  }

  // Function to initialize the database
  Future<void> _initializeDatabase() async {
    await DatabaseService.instance.database; // Wait for the database to get initialized

    setState(() {
      isLoading = false; // Update loading state when the initialization is complete
    });
  }

  // Build method to create the widget tree
  @override
  Widget build(BuildContext context) {
    // If still loading, show a loading indicator
    if (isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Return the main MaterialApp widget
    return MaterialApp(
      title: 'Scbsss',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // Show either the MainTabWidget or the SetupWizard based on the setup completion status
      home: isSetupDone ? MainTabWidget() : SetupWizard(completeSetup),
    );
  }
}
