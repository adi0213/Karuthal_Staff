import 'package:chilla_staff/ApprovalPending.dart';
import 'package:chilla_staff/StudentListForWorkHistory.dart';
import 'package:flutter/material.dart';

import '../AssignServices.dart';
import '../Profile.dart';

//import '../calendar.dart';
import '../customerList.dart';
import '../managerList.dart';
import '../studentslist.dart';

class ManagerDrawer extends StatelessWidget {
  final Map<String, dynamic> details;
  final String token;
  final int managerId;

  ManagerDrawer(
      {required this.details, required this.token, required this.managerId});

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
                        icon: Icon(
                          Icons.menu,
                          color: Color(0xFF60CAD8),
                        ))),
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
            textColor: Color(0xFF60CAD8),
            iconColor: Color(0xFF60CAD8),
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
            textColor: Color(0xFF60CAD8),
            iconColor: Color(0xFF60CAD8),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OwnProfilePage(details: details, userOption: 3)));
            },
          ),
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.manage_accounts),
                  Text('Management '),
                ],
              ),
              textColor: Color(0xFF60CAD8),
              iconColor: Color(0xFF60CAD8),
              collapsedIconColor: Color(0xFF60CAD8),
              collapsedTextColor: Color(0xFF60CAD8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    minTileHeight: 15,
                    title: const Text(
                      'Customers',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.teal),
                    ),
                    onTap: () {
                      print("Customers");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerList(
                                    token: details['authtoken'],
                                  )));
                    },
                    textColor: Color(0xFF60CAD8),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    minTileHeight: 15,
                    title: const Text(
                      'Students',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.teal),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Studentslist(
                                    token: details['authtoken'],
                                  )));
                    },
                    textColor: Color(0xFF60CAD8),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    minTileHeight: 15,
                    title: const Text(
                      'Managers',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.teal),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManagerList(
                                    token: details['authtoken'],
                                  )));
                    },
                    textColor: Color(0xFF60CAD8),
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.assignment_turned_in),
                  Text('Admin Tasks'),
                ],
              ),
              textColor: Color(0xFF60CAD8),
              iconColor: Color(0xFF60CAD8),
              collapsedIconColor: Color(0xFF60CAD8),
              collapsedTextColor: Color(0xFF60CAD8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    minTileHeight: 15,
                    title: Text(
                      'Work History',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.teal),
                    ),
                    onTap: () {
                      print("Work History");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentsListForWorkHistory(
                                    token: details['authtoken'],
                                  )));
                    },
                    textColor: Color(0xFF60CAD8),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    minTileHeight: 15,
                    title: Text(
                      'Approval',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.teal),
                    ),
                    onTap: () {
                      print("Approval");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ApprovalPending(
                                  token: details['authtoken'])));
                    },
                    textColor: Color(0xFF60CAD8),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    minTileHeight: 15,
                    title: Text(
                      'Assign Services',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.teal),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssignService(
                              token: token,
                              details: details,
                              managerId: managerId,
                            ),
                          ));
                    },
                    textColor: Color(0xFF60CAD8),
                  ),
                ),
              ],
            ),
          ),
          /*ListTile(
            title: const Row(
              children: [
                Icon(Icons.calendar_month_sharp),
                Text('Calender'),
              ],
            ),
            textColor: Color(0xFF60CAD8),
            iconColor: Color(0xFF60CAD8),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeCalendarPage()));
            },
          ),*/
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.logout),
                Text('Logout'),
              ],
            ),
            textColor: Color(0xFF60CAD8),
            iconColor: Color(0xFF60CAD8),
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
