import 'package:flutter/material.dart';

class Managerslist extends StatelessWidget {
  final List<Map<String, String>> serviceData = [
    {
      'name': 'John Doe',
      'gender': 'Male',
      'email': 'random@example.com',
      'place': 'pattom,Trivandrum'
    },
    {
      'name': 'Jane Smith',
      'gender': 'Female',
      'email': 'driving@example.com',
      'place': 'pattom,Trivandrum'
    },
    {
      'name': 'Mark Brown',
      'gender': 'Male',
      'email': 'therapy@example.com',
      'place': 'pattom,Trivandrum'
    },
    {
      'name': 'Emily White',
      'gender': 'Female',
      'email': 'companion@example.com',
      'place': 'pattom,Trivandrum'
    },
  ];

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
      ),
      drawer: Drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: buildSearchBar(),
          ),
          Divider(height: 2),
          Expanded(
            child: ListView.builder(
              itemCount: serviceData.length,
              itemBuilder: (context, index) {
                final item = serviceData[index];
                return Column(
                  children: [
                    buildServiceItem(item['name']!, item['gender']!,
                        item['email']!, item['place']!),
                    if (index < serviceData.length - 1) Divider(height: 2),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text('Search by Name', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget buildServiceItem(
      String title, String gender, String email, String place) {
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
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text(' $gender', style: TextStyle(fontSize: 12)),
                Row(
                  children: [
                    Expanded(
                      child: Text(' $email',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                    SizedBox(width: 4), // Space between email and place
                    Icon(Icons.location_on,
                        size: 16, color: Colors.grey), // Location icon
                    SizedBox(width: 4), // Space between icon and place text
                    Text(place,
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
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
