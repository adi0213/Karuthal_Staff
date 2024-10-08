import 'package:chilla_staff/Profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Studentslist extends StatefulWidget {
  final String token;
  const Studentslist({super.key,required this.token});
  @override
  State<Studentslist> createState() => _StudentslistState();
}

class _StudentslistState extends State<Studentslist> {

  late Future<List> Studentslist;
  List students = [];

  Future<List> getStudentDetails() async{
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}'
    };
    final customerDetails = await http.get(
      Uri.parse("http://104.237.9.211:8007/karuthal/api/v1/persona/students"),
      headers: headers,
    );
    var customerDetailsList = jsonDecode(customerDetails.body);
    return customerDetailsList['result'];
  }

  void initState(){
    super.initState();
    Studentslist = getStudentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF60CAD8),
        title: Text(
          'Students List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Icon(Icons.arrow_left))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.arrow_left),
                    Text('Go back'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            // child: buildSearchBar(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search by Username",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none
                    )
                  ),
                  onChanged: searchPerson,
                ),
              ),
            ),
          ),
          Divider(height: 2),
          Expanded(
            child: getList(),
          ),
        ],
      ),
    );
  }

  void searchPerson(String query) {
    setState(() {
      Studentslist = _filterCustomers(query);
    });
    print(query);
  }

  Future<List> _filterCustomers(String query) async {
    if (query.isEmpty) {
      return await getStudentDetails(); 
    }

    final filteredCustomers = (await getStudentDetails()).where((customer) {
      final username = customer['registeredUser']['username']!.toLowerCase();
      final searchQuery = query.toLowerCase();
      return username.contains(searchQuery);
    }).toList();

    return filteredCustomers;
  }

  Widget getList() {
    return FutureBuilder<List>(
      future: Studentslist,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); 
        }
        else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        else if (snapshot.hasData) {
          students = snapshot.data ?? []; 
          if (students.isEmpty) {
            return Center(child: Text("No customers available"));
          }
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Column(
                children: [
                  InkWell(
                    onTap: () => {
                      print(student),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> ProfilePage(details: student, userOption: 2))
                      )
                    },
                    child: buildServiceItem(
                      student['registeredUser']['username']!,
                      student['registeredUser']['email']!,
                      student['age']!,
                      student['course']!,
                    ),
                  ),
                  if (index < students.length - 1) Divider(height: 2),
                ],
              );
            },
          );
        }
        return Center(child: Text("No data available")); 
      },
    );
  }


  Widget buildServiceItem(
      String username, String email, int age, String course) {
        print('$username ,$email ,$age ,$course');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Container(
              color: Colors.grey[300],
              width: 45,
              height: 45,
              child: Icon(Icons.person, color: Colors.grey[700]),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(' $email',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                    SizedBox(width: 4),
                    SizedBox(width: 4),
                    Text('$age, $course',style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
