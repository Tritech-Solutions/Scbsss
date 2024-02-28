// Importing necessary Flutter packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Stateless widget representing a setup wizard
class SetupWizard extends StatelessWidget {
  final void Function() completeSetup; // Callback function to complete setup

  // Constructor to initialize the SetupWizard with a completion callback
  const SetupWizard(this.completeSetup, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold widget for the setup wizard screen
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Welcome to SCBSSS!',
            ),
            const SizedBox(height: 50),
            // Button to complete the setup process
            ElevatedButton(
              onPressed: completeSetup,
              child: const Icon(CupertinoIcons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
