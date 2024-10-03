import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Profile.dart';

class CustomerList extends StatefulWidget {
  final String token;
  const CustomerList({super.key,required this.token});
  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {

  late Future<List> customerList;
  List customers = [];

  Future<List> getCustomerDetails() async{
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}'
    };
    final customerDetails = await http.get(
      Uri.parse("http://104.237.9.211:8007/karuthal/api/v1/persona/customers"),
      headers: headers,
    );
    var customerDetailsList = jsonDecode(customerDetails.body);
    return customerDetailsList;
  }

  void initState(){
    super.initState();
    customerList = getCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF60CAD8),
        title: Text(
          'Customer List',
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
            child: buildSearchBar(),
          ),
          Divider(height: 2),
          Expanded(
            child: getList(),
          ),
        ],
      ),
    );
  }


  Widget getList() {
    return FutureBuilder<List>(
      future: customerList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); 
        }
        else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        else if (snapshot.hasData) {
          customers = snapshot.data ?? []; 
          if (customers.isEmpty) {
            return Center(child: Text("No customers available"));
          }
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return Column(
                children: [
                  InkWell(
                    onTap: (){
                      print(customer);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=> ProfilePage(details: customer, userOption: 1,))
                      );
                    },
                    child: buildServiceItem(
                      customer['registeredUser']['username']!,
                      customer['registeredUser']['email']!,
                      customer['city']!,
                      customer['country']['name']!,
                    ),
                  ),
                  if (index < customers.length - 1) Divider(height: 2),
                ],
              );
            },
          );
        }
        return Center(child: Text("No data available")); 
      },
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
      String username, String email, String city, String country) {
        print('$username ,$email ,$city ,$country');
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
          const SizedBox(width: 8),
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
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('$city, $country',style: TextStyle(fontSize: 12, color: Colors.grey)),
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
