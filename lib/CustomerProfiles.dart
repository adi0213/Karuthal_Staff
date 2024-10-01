import 'package:flutter/material.dart';

class ProfilePage1 extends StatefulWidget {
  const ProfilePage1({super.key});

  @override
  State<ProfilePage1> createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Color(0xFF60CAD8),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: Color(0xFF60CAD8),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            color: Color(0xFF60CAD8),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            color: Color(0xFF60CAD8),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Container(
              width: screenWidth,
              height: screenHeight * 1,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: ClipPath(
              clipper: ClippingClass(),
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.7,
                decoration: BoxDecoration(
                  color: Color(0xFF60CAD8),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Customer",
                style: TextStyle(
                  color: Color(0xFF296685),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.15,
            child: CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: 75,
                color: Colors.grey[700],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.37,
            child: Text(
              'Sufi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned.fill(
            top: screenHeight * 0.45,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextFieldRow('Customer ID', '221'),
                    Divider(color: Colors.white, thickness: 1),
                    buildTextField('Email ID', 'sufi@gmail.com'),
                    Divider(color: Colors.white, thickness: 1),
                    buildTextField('Username', 'km001'),
                    Divider(color: Colors.white, thickness: 1),
                    buildTextField('First Name', 'Neena'),
                    Divider(color: Colors.white, thickness: 1),
                    buildTextField('Last Name', 'M K'),
                    Divider(color: Colors.white, thickness: 1),
                    buildTextField('Phone Number', '+1234567890'),
                    Divider(color: Colors.white, thickness: 1),
                    buildTextField('Address', '123 Main St'),
                    Divider(color: Colors.white, thickness: 1),
                    buildTextField('City', 'Trivandrum'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFieldRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 50);
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    path.quadraticBezierTo(size.width - (size.width / 4), 0, size.width, 50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
