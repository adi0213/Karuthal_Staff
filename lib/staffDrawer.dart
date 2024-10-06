import 'package:flutter/material.dart';
import 'ManagerDashboard.dart';

class StaffDashboard extends StatelessWidget {
  final int loginOption;
  final List? roles;
  const StaffDashboard({super.key, required this.loginOption, this.roles});

  final manager_name = 'managerName!';

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
                onTap: () {},
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
                onTap: () { },
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
                        title: const Text('Users', style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.teal),),
                        onTap: () { },
                        textColor: Colors.teal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        minTileHeight: 15,
                        title: const Text('Customers', style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.teal),),
                        onTap: () {},
                        textColor: Colors.teal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        minTileHeight: 15,
                        title: const Text('Managers', style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.teal),),
                        onTap: () {},
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
                        onTap: () {},
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
                        onTap: () {},
                        textColor: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.feedback),
                    Text('Feedback'),
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
                    Text('Calender'),
                  ],
                ),
                textColor: Colors.teal,
                iconColor: Colors.teal,
                onTap: () {},
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
                onTap: () {},
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
                    'Welcome <$manager_name>',
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
                    'Streamline tasks, monitor progress...',
                    style: TextStyle(
                      color: Colors.teal[300],
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: getBody(loginOption)
                ),
                // Stack(
                //   clipBehavior: Clip.none,
                //   children: [
                //     Container(
                //       height: 160,
                //       color: const Color(0xFFDCFFF7),
                //     ),
                //     Positioned(
                //       top: -30,
                //       bottom: -30,
                //       left: 80,
                //       right: 80,
                //       child: Container(
                //         height: 210,
                //         child: Column(
                //           children: [
                //             BuildViewBar(
                //               identity: 'View Users',
                //               baseColor: const Color(0xFF7FD4C9),
                //               topColor: const Color(0xFF97E0D7),
                //             ),
                //             const SizedBox(height: 15),
                //             BuildViewBar(
                //               identity: 'View Customers',
                //               baseColor: const Color(0xFF78DE90),
                //               topColor: const Color(0xFF80ED99),
                //             ),
                //             const SizedBox(height: 15),
                //             BuildViewBar(
                //               identity: 'View Managers',
                //               baseColor: const Color(0xFF49C38E),
                //               topColor: const Color(0xFF57CC99),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 50),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 40),
                //   child: Column(
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           BuildSquareBox(
                //             baseColor: const Color(0xFF5DC5D2),
                //             tag: 'Student log',
                //             topColor: const Color(0xFF72CDD9),
                //           ),
                //           BuildSquareBox(
                //             baseColor: const Color(0xFF61CDB4),
                //             tag: 'Work History',
                //             topColor: const Color(0xFF72D9C1),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(height: 30),
                //       _approval(),
                //       const SizedBox(height: 30),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           BuildSquareBox(
                //             baseColor: const Color(0xFF6AD683),
                //             tag: 'Assign Services',
                //             topColor: const Color(0xFF78DE90),
                //           ),
                //           BuildSquareBox(
                //             baseColor: const Color(0xFF40B180),
                //             tag: 'Feedback',
                //             topColor: const Color(0xFF49C38E),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getBody(int op){
    if (op==1){
      return Text(
        "This is student Dashboard",
        style: TextStyle(
          color: Colors.teal[300],
          fontSize: 64,
        ),
      );
    }
    else if (op==2){
      return Text(
        "This is customer Dashboard",
        style: TextStyle(
          color: Colors.teal[300],
          fontSize: 64,
        ),
      );
    }
    else if (op==3){
      return Managerdashboard(details: {},);
    }
    else{
      return Text("Role - $roles",
        style: TextStyle(
          color: Colors.teal[300],
          fontSize: 64,
        ),
      );
    }
  }

  GestureDetector _approval() {
    return GestureDetector(
      onTap:(){},
        child: Stack(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF2EA87C),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipPath(
                    clipper: WaveClipperApproval(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF37B488),
                      ),
                      height: 100,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Approval',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Approve pending logins and items requiring your authentication',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
    ));
  }
}

class WaveClipperApproval extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    debugPrint(size.width.toString());

    path.lineTo(0, size.height);

    var firstStart = Offset(size.width * 0.33, size.height);
    var firstEnd = Offset(size.width * 0.5, size.height / 2);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width * 0.75, size.height - (size.height * 1));
    var secondEnd = Offset(size.width, 0);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BuildSquareBox extends StatelessWidget {
  final String tag;
  final Color baseColor;
  final Color topColor;

  BuildSquareBox({
    required this.baseColor,
    required this.tag,
    required this.topColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 170,
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              spreadRadius: 3,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            ClipPath(
              clipper: WaveClipperSquare(),
              child: Container(
                decoration: BoxDecoration(
                  color: topColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Center(
              child: Text(
                tag,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipperSquare extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    debugPrint(size.width.toString());
    path.lineTo(0, size.height);

    var firstStart = Offset(size.width * 0.33, size.height);
    var firstEnd = Offset(size.width * 0.5, size.height / 2);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width * 0.75, size.height - (size.height * 1));
    var secondEnd = Offset(size.width, 0);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BuildViewBar extends StatelessWidget {
  final String identity;
  final Color baseColor;
  final Color topColor;

  BuildViewBar({
    required this.identity,
    required this.baseColor,
    required this.topColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 3,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () => {},
          child: Stack(
            children: [
              Container(
                height: 61,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 61,
                  color: topColor,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    identity,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    final path = Path();
    path.lineTo(0, size.height);

    var firstStart = Offset(size.width * 0.37, size.height);
    var firstEnd = Offset(size.width * 0.5, size.height - 30);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width * 0.70, size.height - 58);
    var secondEnd = Offset(size.width, 0);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}