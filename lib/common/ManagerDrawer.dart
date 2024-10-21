import 'package:flutter/material.dart';

import '../AssignServices.dart';
import '../Profile.dart';
import '../StudentAssignedServices.dart';
import '../calendar.dart';
import '../customerList.dart';
import '../managerList.dart';
import '../studentslist.dart';
import '../workHistory.dart';

class ManagerDrawer extends StatelessWidget {
  final Map<String, dynamic> details;
  final String token;
  final int managerId;

  ManagerDrawer({required this.details, required this.token, required this.managerId});

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
                        child: IconButton(onPressed: () => {Navigator.pop(context)},
                        icon: Icon(Icons.menu, color: Colors.teal,))
                      ),
                      IconButton(onPressed: () => {}, icon: Icon(Icons.account_circle, color: Colors.teal,)),
                    ],
                  )
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
                onTap: () {Navigator.pop(context);},
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
                    MaterialPageRoute(builder: (context)=>OwnProfilePage(details: details, userOption: 3))
                  );
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
                  textColor: Colors.teal,
                  iconColor: Colors.teal,
                  collapsedIconColor: Colors.teal,
                  collapsedTextColor: Colors.teal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        minTileHeight: 15,
                        title: const Text('Customers', style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.teal),),
                        onTap: () {
                          print("Customers");
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context)=>CustomerList(token: details['authtoken'],)
                            )
                          );
                        },
                        textColor: Colors.teal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        minTileHeight: 15,
                        title: const Text('Students', style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.teal),),
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context)=>Studentslist( token: details['authtoken'],)
                            )
                          );
                        },
                        textColor: Colors.teal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        minTileHeight: 15,
                        title: const Text('Managers', style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.teal),),
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context)=>ManagerList( token: details['authtoken'],)
                            )
                          );
                        },
                        textColor: Colors.teal,
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
                  textColor: Colors.teal,
                  iconColor: Colors.teal,
                  collapsedIconColor: Colors.teal,
                  collapsedTextColor: Colors.teal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        minTileHeight: 15,
                        title: Text('Student Log', style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.teal),),
                        onTap: () {},
                        textColor: Colors.teal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        minTileHeight: 15,
                        title: Text('Work History', style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.teal),),
                        onTap: () {
                          print("Work History");
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context)=>WorkHistory(token: details['authtoken'],)
                            )
                          );
                        },
                        textColor: Colors.teal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        minTileHeight: 15,
                        title: Text('Approval', style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.teal),),
                        onTap: () {},
                        textColor: Colors.teal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        minTileHeight: 15,
                        title: Text('Assign Services', style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.teal),),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context)=> AssignService(token: token,  details: details, managerId: managerId,),
                            )
                          );
                        },
                        textColor: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
             
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.calendar_month_sharp),
                    Text('Calender'),
                  ],
                ),
                textColor: Colors.teal,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context)=>HomeCalendarPage())
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
