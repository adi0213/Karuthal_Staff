import 'package:flutter/material.dart';
import 'StudentDrawer.dart';

class StudentDashboard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String token;
  final String email;
  final String id;
  final int studentId;
  final Map<String, dynamic> details;

  final String studentName;

  StudentDashboard({super.key, required this.details})
      : firstName = details['firstName'] ?? '',
        lastName = details['lastName'] ?? '',
        token = details['authtoken'] ?? '',
        email = details['email'] ?? '',
        id = details['id'] ?? '',
        studentId = details['studentId'] ?? 0,
        studentName = '${details['firstName'] ?? ''} ${details['lastName'] ?? ''}';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.teal),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.teal),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.teal),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.teal),
              onPressed: () {},
            ),
          ],
        ),
        drawer: StudentDrawer(
          details: details,
          token: details['authtoken'] ?? '',
          studentId: details['studentId'] ?? 0,
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Welcome, $studentName',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Streamline tasks and monitor your progress',
                    style: TextStyle(
                      color: Colors.teal[300],
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildDashboardCards(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Card for Upcoming Tasks
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upcoming Tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Add a list of upcoming tasks or notifications here
                  Text('1. Submit project report by Friday'),
                  Text('2. Attend group meeting on Saturday'),
                  Text('3. Review service feedback'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Card for Assigned Services
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Assigned Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Add a list of assigned services or a button to navigate
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to assigned services page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Button color
                    ),
                    child: const Text('View Assigned Services'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Card for Performance Overview
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Placeholder for performance statistics
                  Text('Tasks Completed: 5/10'),
                  Text('Pending Feedback: 2'),
                  Text('Average Rating: 4.5/5'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
