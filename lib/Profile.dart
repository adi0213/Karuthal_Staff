import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> details;
  final int userOption;
  const ProfilePage(
      {super.key, required this.details, required this.userOption});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var name = "${widget.details['registeredUser']['firstName']}" != "null"
        ? "${widget.details['registeredUser']['firstName']} ${widget.details['registeredUser']['lastName']}"
        : "Unknown";

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Color(0xFF60CAD8),
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
              child: Row(
                children: [
                  Text(
                    "Profile Details",
                    style: TextStyle(
                      color: Color(0xFF296685),
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
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
              name,
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
                child: buildDetails(widget.userOption),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetails(int op) {
    if (op == 1) {
      // Customer
      var customerId = "${widget.details['customerId']}";
      var email = "${widget.details['registeredUser']['email']}";
      var mobile = "${widget.details['registeredUser']['mobile']}" != "null"
          ? "${widget.details['registeredUser']['mobile']}"
          : "Unknown";
      var username = "${widget.details['registeredUser']['username']}";
      var fName = "${widget.details['registeredUser']['firstName']}" != "null"
          ? "${widget.details['firstName']}"
          : "Unknown";
      var lName = "${widget.details['registeredUser']['lastName']}" != "null"
          ? "${widget.details['lastName']}"
          : "Unknown";
      var job = "${widget.details['job']}" != "null"
          ? "${widget.details['job']}"
          : "Unknown";
      var city = "${widget.details['city']}" != "null"
          ? "${widget.details['city']}"
          : "Unknown";
      var country = "${widget.details['country']}" != "null"
          ? "${widget.details['country']}"
          : "Unknown";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetBuilder.buildTextFieldRow('Customer ID', customerId),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Email ID', email),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Mobile', mobile),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Username', username),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('First Name', fName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Last Name', lName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Job', job),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('City', city),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Country', country),
        ],
      );
    } else if (op == 2) {
      // Student
      var studentId = "${widget.details['studentId']}";
      var email = "${widget.details['registeredUser']['email']}";
      var mobile = "${widget.details['registeredUser']['mobile']}" != "null"
          ? "${widget.details['registeredUser']['mobile']}"
          : "Unknown";
      var username = "${widget.details['registeredUser']['username']}";
      var fName = "${widget.details['registeredUser']['firstName']}" != "null"
          ? "${widget.details['firstName']}"
          : "Unknown";
      var lName = "${widget.details['registeredUser']['lastName']}" != "null"
          ? "${widget.details['lastName']}"
          : "Unknown";
      var course = "${widget.details['course']}";
      var age = "${widget.details['age']}";
      var gender = "${widget.details['gender']}" != "null"
          ? "${widget.details['gender']}"
          : "Unknown";
      var address = "${widget.details['registeredUser']['address']}" != "null"
          ? "${widget.details['registeredUser']['address']}"
          : "Unknown";
      var city = "${widget.details['registeredUser']['city']}" != "null"
          ? "${widget.details['registeredUser']['city']}"
          : "Unknown";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetBuilder.buildTextFieldRow('Student ID', studentId),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Email ID', email),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Mobile', mobile),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Username', username),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('First Name', fName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Last Name', lName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Course', course),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Age', age),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Gender', gender),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Address', address),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('City', city),
        ],
      );
    } else if (op == 3) {
      // Manager
      var managerId = "${widget.details['managerId']}";
      var email = "${widget.details['registeredUser']['email']}";
      var mobile = "${widget.details['registeredUser']['mobile']}" != "null"
          ? "${widget.details['registeredUser']['mobile']}"
          : "Unknown";
      var username = "${widget.details['registeredUser']['username']}";
      var fName = "${widget.details['registeredUser']['firstName']}" != "null"
          ? "${widget.details['firstName']}"
          : "Unknown";
      var lName = "${widget.details['registeredUser']['lastName']}" != "null"
          ? "${widget.details['lastName']}"
          : "Unknown";
      var roles =
          "${widget.details['registeredUser']['assignedRoles']}" != "null"
              ? "${widget.details['gender']}"
              : "Unknown";
      var address = "${widget.details['registeredUser']['address']}" != "null"
          ? "${widget.details['registeredUser']['address']}"
          : "Unknown";
      var city = "${widget.details['registeredUser']['city']}" != "null"
          ? "${widget.details['registeredUser']['city']}"
          : "Unknown";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetBuilder.buildTextFieldRow('Manager ID', managerId),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Email ID', email),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Mobile', mobile),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Username', username),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('First Name', fName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Last Name', lName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Roles', roles),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Address', address),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('City', city),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class OwnProfilePage extends StatefulWidget {
  final Map<String, dynamic> details;
  final int userOption;
  const OwnProfilePage(
      {super.key, required this.details, required this.userOption});

  @override
  State<OwnProfilePage> createState() => _OwnProfilePageState();
}

class _OwnProfilePageState extends State<OwnProfilePage> {
  @override
  Widget build(BuildContext context) {
    var name = "${widget.details['firstName']}" != "null"
        ? "${widget.details['firstName']} ${widget.details['lastName']}"
        : "Unknown";

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Color(0xFF60CAD8),
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
              child: Row(
                children: [
                  Text(
                    "Profile Details",
                    style: TextStyle(
                      color: Color(0xFF296685),
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
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
              name,
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
                child: buildDetails(widget.userOption),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetails(int op) {
    if (op == 1) {
      // Customer
      var customerId = "${widget.details['customerId']}";
      var email = "${widget.details['registeredUser']['email']}";
      var mobile = "${widget.details['registeredUser']['mobile']}" != "null"
          ? "${widget.details['registeredUser']['mobile']}"
          : "Unknown";
      var username = "${widget.details['registeredUser']['username']}";
      var fName = "${widget.details['registeredUser']['firstName']}" != "null"
          ? "${widget.details['firstName']}"
          : "Unknown";
      var lName = "${widget.details['registeredUser']['lastName']}" != "null"
          ? "${widget.details['lastName']}"
          : "Unknown";
      var job = "${widget.details['job']}";
      var city = "${widget.details['city']}";
      var country = "${widget.details['country']['name']}";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetBuilder.buildTextFieldRow('Customer ID', customerId),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Email ID', email),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Mobile', mobile),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Username', username),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('First Name', fName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Last Name', lName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Job', job),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('City', city),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Country', country),
        ],
      );
    } else if (op == 2) {
      // Student
      var studentId = "${widget.details['studentId']}";
      var email = "${widget.details['email']}";
      var mobile = "${widget.details['mobile']}" != "null"
          ? "${widget.details['registeredUser']['mobile']}"
          : "Unknown";
      var username = "${widget.details['username']}";
      var fName = "${widget.details['firstName']}" != "null"
          ? "${widget.details['firstName']}"
          : "Unknown";
      var lName = "${widget.details['lastName']}" != "null"
          ? "${widget.details['lastName']}"
          : "Unknown";
      // var course = "${widget.details['course']}";
      // var age = "${widget.details['age']}";
      // var gender = "${widget.details['gender']}" != "null" ? "${widget.details['gender']}" : "Unknown";
      var address = "${widget.details['address']}" != "null"
          ? "${widget.details['registeredUser']['address']}"
          : "Unknown";
      var city = "${widget.details['city']}" != "null"
          ? "${widget.details['registeredUser']['city']}"
          : "Unknown";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetBuilder.buildTextFieldRow('Student ID', studentId),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Email ID', email),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Mobile', mobile),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Username', username),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('First Name', fName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Last Name', lName),
          // Divider(color: Colors.white, thickness: 1),
          // WidgetBuilder.buildTextField('Course', course),
          // Divider(color: Colors.white, thickness: 1),
          // WidgetBuilder.buildTextField('Age', age),
          // Divider(color: Colors.white, thickness: 1),
          // WidgetBuilder.buildTextField('Gender', gender),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Address', address),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('City', city),
        ],
      );
    } else if (op == 3) {
      // Manager
      var email = "${widget.details['email']}";
      var mobile = "${widget.details['mobile']}" != "null"
          ? "${widget.details['registeredUser']['mobile']}"
          : "Unknown";
      var username = "${widget.details['username']}";
      var fName = "${widget.details['firstName']}" != "null"
          ? "${widget.details['firstName']}"
          : "Unknown";
      var lName = "${widget.details['lastName']}" != "null"
          ? "${widget.details['lastName']}"
          : "Unknown";
      var roles = "${widget.details['assignedRoles']}" != "null"
          ? "${widget.details['assignedRoles']}" as String
          : "Unknown";
      var address = "${widget.details['address']}" != "null"
          ? "${widget.details['registeredUser']['address']}"
          : "Unknown";
      var city = "${widget.details['city']}" != "null"
          ? "${widget.details['registeredUser']['city']}"
          : "Unknown";
      print(widget.details['assignedRoles']);
      roles = roles.substring(1, roles.length - 1);
      print(roles);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetBuilder.buildTextField('Email ID', email),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Mobile', mobile),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Username', username),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('First Name', fName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Last Name', lName),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Roles', roles),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('Address', address),
          Divider(color: Colors.white, thickness: 1),
          WidgetBuilder.buildTextField('City', city),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class WidgetBuilder {
  static buildTextFieldRow(String label, String value) {
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

  static Widget buildTextField(String label, String value) {
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
