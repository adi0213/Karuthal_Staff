import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceDetails extends StatefulWidget {
  final int bookingId;
  final String token;
  const ServiceDetails({super.key, required this.token, required this.bookingId});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {

  var currentBookingDetails;
  var studentsList;
  int noOfStudents=0;
  List<int> selectedStudentsId = [];

  void initState(){
    super.initState();
    fetchBookingDeatils();
  }

  void fetchBookingDeatils() async{
    currentBookingDetails = await getBookingDetails();
    studentsList = await getStudents();
    noOfStudents = studentsList.length;
    setState(() {});
  }

  Future<Map<String,dynamic>> getBookingDetails() async{
    final headers = {
      "Content-Type" : "application/json",
      "Authorization" : "Bearer ${widget.token}"
    };
    
    var bookingDetails = await http.get(
      Uri.parse("http://104.237.9.211:8007/karuthal/api/v1/bookingrequest/${widget.bookingId}"),
      headers: headers
    );
    return jsonDecode(bookingDetails.body);
  }

  Future<List> getStudents() async{
    var bookingDetails;
    try{
      final headers = {
      "Content-Type" : "application/json",
      "Authorization" : "Bearer ${widget.token}"
    };
    bookingDetails = await http.get(
      Uri.parse("http://104.237.9.211:8007/karuthal/api/v1/persona/students"),
      headers: headers
    );
    }
    catch(e){
      print(e);
    }
    finally{
      if(bookingDetails.statusCode == 200){
        return jsonDecode(bookingDetails.body)['result'];
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color(0xFF57CC99),
              content: Text(
                '${jsonDecode(bookingDetails.body)['message']}',
              style: TextStyle(color: Colors.black),
              ),
            ),
          );
        return [];
      }
    }
  }

  Future<void> assignStudents() async{
    final headers = {
      "Content-Type" : "application/json",
      "Authorization" : "Bearer ${widget.token}"
    };
    final body = {
      "managerId" : 28,
      "bookingRequestId" : widget.bookingId,
      "studentIds" : selectedStudentsId
    };
    try{
      var response = await http.put(
        Uri.parse("http://104.237.9.211:8007/karuthal/api/v1/staff/assignstudents"),
        headers: headers,
        body: jsonEncode(body)
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200){
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Successful'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('${jsonDecode(response.body)['message']}'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      }
      else{
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Unsuccessful'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('${jsonDecode(response.body)['message']}'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      }
    }catch(e){
      print(e);
    }
  }

  Widget getValue(data){
    String value = data == "false" ? "No":"Yes";
    return Text(value);
  }

  @override
  Widget build(BuildContext context) {
    if(currentBookingDetails == null){
      return Center(child: CircularProgressIndicator(),);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
        ],
      ),
      drawer: Drawer(
        // Add a drawer here if necessary
        child: ElevatedButton(onPressed: (){
          Navigator.pop(context);
          Navigator.pop(context);
        },child: const Text("Go Back")),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              color: Colors.teal,
              width: MediaQuery.sizeOf(context).width,
              // child: Text(
              //   "Booking Details of Customer ID: 2255",
              //   style: TextStyle(
              //     fontSize: 20,
              //     color: Colors.white,
              //     fontWeight: FontWeight.bold
              //   ),
              // ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                  children: [
                    const TextSpan(text: "Booking Details of Booking ID: "),
                    TextSpan(text: "${currentBookingDetails['result']['id']}", style: const TextStyle(fontWeight: FontWeight.bold))
                  ]
                ),
              ),
            ),
            
            const SizedBox(height: 16,),
            // Customer details card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Customer details",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Customer Id: ${currentBookingDetails['result']['enrolledByCustomer']['customerId']}'),
                      Text("Customer name: ${currentBookingDetails['result']['enrolledByCustomer']['registeredUser']['firstName']} ${currentBookingDetails['result']['enrolledByCustomer']['registeredUser']['lastName']}"),
                      Text("Customer username: ${currentBookingDetails['result']['enrolledByCustomer']['registeredUser']['username']}"),
                      Text("Job: ${currentBookingDetails['result']['enrolledByCustomer']['job']}"),
                    ],
                  ),
                ),
              ),
            ),
            
            // Patient list expandable
            const SizedBox(height: 16),

            // Services required card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Patient List",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          for(int i=0;i<currentBookingDetails['result']['requestedFor'].length;i++)
                            Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Table(
                                    columnWidths: const {
                                      0: IntrinsicColumnWidth(),
                                      1: FixedColumnWidth(20)
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          const Text("Patient Id "),
                                          const Text(":"),
                                          Text("${currentBookingDetails['result']['requestedFor'][i]['patientId']}")
                                        ]
                                      ),
                                      TableRow(
                                        children: [
                                          const Text("Patient Name "),
                                          const Text(":"),
                                          Text("${currentBookingDetails['result']['requestedFor'][i]['firstName']} ${currentBookingDetails['result']['requestedFor'][i]['lastName']}")
                                        ]
                                      ),
                                      TableRow(
                                        children: [
                                          const Text("Patient Age "),
                                          const Text(":"),
                                          Text("${currentBookingDetails['result']['requestedFor'][i]['age']}")
                                        ]
                                      ),
                                      TableRow(
                                        children: [
                                          const Text("Patient Gender "),
                                          const Text(":"),
                                          Text("${currentBookingDetails['result']['requestedFor'][i]['gender']}")
                                        ]
                                      ),
                                      TableRow(
                                        children: [
                                          const Text("Health Description "),
                                          const Text(":"),
                                          Text("${currentBookingDetails['result']['requestedFor'][i]['healthDescription']}")
                                        ]
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,)
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Services required card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Services Required",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Column(
                        children: [
                          for(int i=0;i<currentBookingDetails['result']['requestedServices'].length;i++)
                          Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Table(
                                  columnWidths: const {
                                    0: IntrinsicColumnWidth(),
                                    1: FixedColumnWidth(20)
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        const Text("Service Id "),
                                        const Text(":"),     
                                        Text("${currentBookingDetails['result']['requestedServices'][i]['id']}")
                                      ]
                                    ),
                                    TableRow(
                                      children: [
                                        const Text("Service Name "),
                                        const Text(":"),
                                        Text("${currentBookingDetails['result']['requestedServices'][i]['name']}")
                                      ]
                                    ),
                                    TableRow(
                                      children: [
                                        const Text("Description "),
                                        const Text(":"),
                                        Text("${currentBookingDetails['result']['requestedServices'][i]['description']}")
                                      ]
                                    ),
                                    TableRow(
                                      children: [
                                        const Text("Value Added "),
                                        const Text(":"),
                                        getValue("${currentBookingDetails['result']['requestedServices'][i]['valueAdded']}"),
                                      ]
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Additional services card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Additional services",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          for (int i=0;i<1;i++)
                          Text("Currently Nothing ${i+1}")
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "Available Students",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search here...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                ),
              ),
            ),

            // Search Filters expandable
            // const ExpansionTile(
            //   title: Text("Search Filters"),
            //   children: [
            //     // Add search filter details here
            //   ],
            // ),

            // Student list (mocked data)
            ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              padding: EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(), // To prevent nested scrolling
              shrinkWrap: true, // Make sure the list only takes needed space
              itemCount: noOfStudents, // Adjust based on actual data
              itemBuilder: (context, index) {
                final student = studentsList[index];
                return ListTile(
                  title: Text("Student Id: ${student['studentId']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${student['registeredUser']['firstName']} ${student['registeredUser']['lastName']}"),
                      Text("Username: ${student['registeredUser']['username']}"),
                    ],
                  ),
                  selected: selectedStudentsId.contains(student['studentId']),
                  selectedColor: Colors.white,
                  selectedTileColor: Colors.teal,
                  onTap: () => {
                    setState(() {
                      if(selectedStudentsId.contains(student['studentId'])){
                        selectedStudentsId.remove(student['studentId']);
                      }
                      else{
                        selectedStudentsId.add(student['studentId']);
                      }
                    })
                  },
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  onPressed: (){
                    assignStudents();
                  },
                  child: const Text("Assign Service",style: TextStyle(color: Colors.white),)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
