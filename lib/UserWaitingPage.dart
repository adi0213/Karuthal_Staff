import 'package:flutter/material.dart';

class UserWaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
        backgroundColor: const Color(0xFF38A3A5), // Customize your app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Optional: You can add an image or icon here
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: const Color(0xFF38A3A5), // Icon color
              ),
              const SizedBox(height: 20),
              Text(
                'Request Received!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We have received your request. Once the Administrator approves your request, you will receive the credential details in the registered email.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center, // Correctly placed here
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Optionally, navigate back to a specific page
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38A3A5), // Corrected parameter for button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
