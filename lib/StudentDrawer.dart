import 'package:flutter/material.dart';
import 'CompleteTheWork.dart';
import 'Profile.dart';
import 'StudentAssignedServices.dart';
import 'StudentWorkLog.dart';
import 'StudentWorklogHistory.dart';
import 'calendar.dart';
import 'StudentDashboard.dart';

class StudentDrawer extends StatelessWidget {
  final Map<String, dynamic> details;
  final String token;
  final int studentId;

  StudentDrawer({required this.details, required this.token, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                      icon: Icon(Icons.menu, color: Colors.teal),
                    ),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: Icon(Icons.account_circle, color: Colors.teal),
                  ),
                ],
              ),
            ),
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
                // Navigate to StudentDashboard
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDashboard(details: details), 
                  ),
                );
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
                  builder: (context) => OwnProfilePage(details: details, userOption: 2),
                ),
              );
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
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(child: CircularProgressIndicator()),
              );

              try {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentAssignedServices(token: token, studentId: studentId, details: details,),
                  ),
                );
              } catch (e) {
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
                Text('Start work'),
              ],
            ),
            textColor: Colors.teal,
            iconColor: Colors.teal,
            onTap: () {
              // Navigate to the WorkLogForm widget
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkLogForm(token: token, studentId: studentId, details: details,)),
              );
            },
          ),

          ListTile(
            title: const Row(
              children: [
                Icon(Icons.person),
                Text('Complete work'),
              ],
            ),
            textColor: Colors.teal,
            iconColor: Colors.teal,
            onTap: () {
              // Navigate to the WorkLogForm widget
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompleteWorkLogForm(token: token, studentId: studentId, details: details,)),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.history),
                Text('Work History'),
              ],
            ),
            textColor: Colors.teal,
            iconColor: Colors.teal,
            onTap: () {
              // Navigate to the StudentWorkLogHistory widget
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentWorkLogHistory(token: token, studentId: studentId, details: details)),
              );
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
    );
  }
}
