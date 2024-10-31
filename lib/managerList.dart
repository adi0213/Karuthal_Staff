import 'package:chilla_staff/Profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManagerList extends StatefulWidget {
  final String token;
  const ManagerList({super.key, required this.token});
  @override
  State<ManagerList> createState() => _ManagerListState();
}

class _ManagerListState extends State<ManagerList> {
  late Future<List> ManagerList;
  List managers = [];

  Future<List> getManagerDetails() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}'
    };
    final customerDetails = await http.get(
      Uri.parse("http://104.237.9.211:8007/karuthal/api/v1/persona/managers"),
      headers: headers,
    );
    var managerDetailsList = jsonDecode(customerDetails.body);
    return managerDetailsList['result'];
  }

  void initState() {
    super.initState();
    ManagerList = getManagerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF60CAD8),
        title: Text(
          'Managers List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Color.fromARGB(255, 255, 255, 255),
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
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
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
      ManagerList = _filterCustomers(query);
    });
    print(query);
  }

  Future<List> _filterCustomers(String query) async {
    if (query.isEmpty) {
      return await getManagerDetails();
    }

    final filteredCustomers = (await getManagerDetails()).where((customer) {
      final username = customer['registeredUser']['username']!.toLowerCase();
      final searchQuery = query.toLowerCase();
      return username.contains(searchQuery);
    }).toList();

    return filteredCustomers;
  }

  Widget getList() {
    return FutureBuilder<List>(
      future: ManagerList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          managers = snapshot.data ?? [];
          if (managers.isEmpty) {
            return Center(child: Text("No customers available"));
          }
          return ListView.builder(
            itemCount: managers.length,
            itemBuilder: (context, index) {
              final manager = managers[index];
              return Column(
                children: [
                  InkWell(
                    onTap: () => {
                      print(manager),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(details: manager, userOption: 3)))
                    },
                    child: buildServiceItem(
                      manager['registeredUser']['username']!,
                      manager['registeredUser']['email']!,
                    ),
                  ),
                  if (index < managers.length - 1) Divider(height: 2),
                ],
              );
            },
          );
        }
        return Center(child: Text("No data available"));
      },
    );
  }

  Widget buildServiceItem(String username, String email) {
    print('$username ,$email');
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
