import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ServiceDetails.dart';

class AssignService extends StatefulWidget {
  final String token;
  const AssignService({super.key,required this.token});

  State<AssignService> createState()=>_AssignServiceState();
}

class _AssignServiceState extends State<AssignService> {
  List bookingRequestsList = [];

  void initState(){
    super.initState();
    fetchRequests();
  }

  void fetchRequests() async{
    bookingRequestsList = await getRequests();
    setState(() {});
  }

  Future<List> getRequests() async{
    final Map<String,String> headers = {
      'Content-Type': 'application/json',
      'Authorization':'Bearer ${widget.token}'
    };

    final bookingRequests = await http.get(
      Uri.parse("http://104.237.9.211:8007/karuthal/api/v1/bookingrequest"),
      headers: headers
    );
    //print(await jsonDecode(bookingRequests.body));
    var bookingrequestdetails = jsonDecode(bookingRequests.body);
    return bookingrequestdetails['result'];
  }

  String filter = 'All';
  String activeIcon = 'None';

  String formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    print(widget.token);
    print("HI: $bookingRequestsList");
    if (bookingRequestsList.length == 0){
      return Center(child: CircularProgressIndicator());
    }
    else{
      List<dynamic> filteredBookingRequests = filter == 'All'
          ? bookingRequestsList: bookingRequestsList.where((request)=>request['status'] == filter).toList();

      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color(0xFF38A3A5),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Color(0xFF38A3A5),
              ),
              onPressed: () {
                setState(() {
                  activeIcon = 'Notification';
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Color(0xFF38A3A5),
              ),
              onPressed: () {
                setState(() {
                  activeIcon = 'Settings';
                });
              },
            ),
            IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_2,
                  color: Color(0xFF38A3A5),
                ),
              ),
              onPressed: () {
                setState(() {
                  activeIcon = 'Profile';
                });
              },
            ),
            SizedBox(width: 16),
          ],
        ),
        drawer: Drawer(
          child: ElevatedButton(onPressed: (){Navigator.pop(context);Navigator.pop(context);}, child: Text("Go Back")),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Request',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF38A3A5)),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = 'All';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filter == 'All'
                          ? Color(0xFF38A3A5)
                          : const Color.fromARGB(255, 225, 222, 222),
                    ),
                    child: Text(
                      'All',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = 'Approved';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filter == 'Approved'
                          ? Color(0xFF38A3A5)
                          : const Color.fromARGB(255, 225, 222, 222),
                    ),
                    child: Text(
                      'Approved',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = 'Pending';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filter == 'Pending'
                          ? Color(0xFF38A3A5)
                          : const Color.fromARGB(255, 225, 222, 222),
                    ),
                    child: Text(
                      'Pending',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Builder(
                builder: (context) {
                  if(filteredBookingRequests.isEmpty){
                    return Center(
                      child: Text("No Requests Available"),
                    );
                  }
                  return ListView.separated(
                    itemCount: bookingRequestsList.length,
                    separatorBuilder: (context, index) => Divider(),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final request = filteredBookingRequests[index];
                      return InkWell(
                        onTap: () {
                          print("Tapped ${request['id']}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>ServiceDetails(token: widget.token, bookingId: request['id'],))
                          );                        
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Customer ID: ${request['enrolledByCustomer']['customerId']}'),
                                Text('Name: ${request['enrolledByCustomer']['registeredUser']['email']}'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Rand"),
                                Text(
                                  request['status'],
                                  style: TextStyle(
                                    color: request['status'] == 'Approved'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              ),
            ],
          ),
        ),
      );
    }
  }
}