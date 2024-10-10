import 'dart:convert';

import 'package:flutter/material.dart';
import 'Profile.dart';
import 'StudentAssignedServices.dart';
import 'calendar.dart';
import 'package:http/http.dart' as http;

class Studentdashboard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String token;
  final String email;
  final String id;
  final int studentId;
  final Map<String, dynamic> details;

  final student_name;


  Studentdashboard({super.key, required this.details})
      : firstName = details['firstName'] ?? '', 
        lastName = details['lastName'] ?? '',
        token = details['authtoken'] ?? '', 
        email = details['email'] ?? '', 
        id = details['id'] ?? '',
        studentId = details['studentId'] ?? '',
        student_name = '${details['firstName'] ?? ''} ${details['lastName'] ?? ''}';
        




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.teal),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.teal),
              onPressed: () => {},
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.teal),
              onPressed: () => {},
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.teal),
              onPressed: () => {},
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 75,
                child: DrawerHeader(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RotatedBox(
                        quarterTurns: 1,
                        child: IconButton(
                            onPressed: () => {Navigator.pop(context)},
                            icon: Icon(
                              Icons.menu,
                              color: Colors.teal,
                            ))),
                    IconButton(
                        onPressed: () => {},
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.teal,
                        )),
                  ],
                )),
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.space_dashboard_sharp),
                    Text('Dashboard'),
                  ],
                ),
                textColor: Colors.teal,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.person),
                    Text('View Profile'),
                  ],
                ),
                textColor: Colors.teal,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OwnProfilePage(details: details, userOption: 2)));
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.assignment),
                    Text('Assignments'),
                  ],
                ),
                textColor: Colors.teal,
                iconColor: Colors.teal,
                onTap: () async {
                  // Show a loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(child: CircularProgressIndicator()),
                  );

                  try {
                    // Fetch assignments data from the backend
                    //List<dynamic> assignments = await fetchAssignments();

                    Navigator.pop(context);
                    Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>StudentAssignedServices(token:token, studentId: 44,))
                          ); 
                  } catch (e) {
                    // Handle errors by popping the loading indicator and showing an error message
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to load assignments: $e')),
                    );
                  }
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.person),
                    Text('Log Book'),
                  ],
                ),
                textColor: Colors.teal,
                iconColor: Colors.teal,
                onTap: () {},
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.feedback),
                    Text('Work History'),
                  ],
                ),
                textColor: Colors.teal,
                iconColor: Colors.teal,
                onTap: () {},
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.calendar_month_sharp),
                    Text('Calendar'),
                  ],
                ),
                textColor: Colors.teal,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeCalendarPage()));
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.logout),
                    Text('Logout'),
                  ],
                ),
                textColor: Colors.teal,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
                    'Welcome <$student_name>',
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
                    'Streamline tasks, monitor progress.sdfs..',
                    style: TextStyle(
                      color: Colors.teal[300],
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "This is Student Dashboard",
                      style: TextStyle(
                        color: Colors.teal[300],
                        fontSize: 64,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}


