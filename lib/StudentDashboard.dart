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

  // Added: URL for the student photo
  final String photoUrl;

  StudentDashboard({super.key, required this.details})
      : firstName = details['firstName'] ?? '',
        lastName = details['lastName'] ?? '',
        token = details['authtoken'] ?? '',
        email = details['email'] ?? '',
        id = details['id'] ?? '',
        studentId = details['studentId'] ?? 0,
        photoUrl = details['photoUrl'] ?? '',
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
              crossAxisAlignment: CrossAxisAlignment.center, // Center all elements
              children: [
                // User photo and welcome text
                _buildUserProfile(),
                const SizedBox(height: 30),
                _buildDashboardCards(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build user profile section with photo and welcome message
  Widget _buildUserProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // User profile photo
          CircleAvatar(
            radius: 50,
            backgroundImage: photoUrl.isNotEmpty
                ? NetworkImage(photoUrl)
                : const AssetImage('default_avatar.PNG')
                    as ImageProvider, // Placeholder if no photoUrl
          ),
          const SizedBox(height: 16),

          // Welcome text
          Text(
            'Welcome, $studentName',
            style: const TextStyle(
              fontSize: 28,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Streamline tasks and monitor your progress',
            style: TextStyle(
              color: Colors.teal[300],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Build the dashboard cards
  Widget _buildDashboardCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildCard(
            title: 'Upcoming Tasks',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('1. Submit project report by Friday'),
                Text('2. Attend group meeting on Saturday'),
                Text('3. Review service feedback'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildCard(
            title: 'Assigned Services',
            content: ElevatedButton(
              onPressed: () {
                // Navigate to assigned services page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button color
              ),
              child: const Text('View Assigned Services'),
            ),
          ),
          const SizedBox(height: 20),

          _buildCard(
            title: 'Performance Overview',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Tasks Completed: 5/10'),
                Text('Pending Feedback: 2'),
                Text('Average Rating: 4.5/5'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Utility function to build a consistent card layout
  Widget _buildCard({required String title, required Widget content}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }
}
