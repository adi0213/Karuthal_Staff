import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'global_api_constants.dart';

class StudentAssignedServices extends StatefulWidget {
  final String token;
  final int studentId;
  const StudentAssignedServices(
      {super.key, required this.token, required this.studentId});

  @override
  State<StudentAssignedServices> createState() =>
      _StudentAssignedServicesState();
}

class _StudentAssignedServicesState extends State<StudentAssignedServices> {
  var currentBookingDetails;
  List<int> bookingRequestIds = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
  }

  void fetchBookingDetails() async {
    bookingRequestIds = await fetchAssignments();
    if (bookingRequestIds.isNotEmpty) {
      await getBookingDetails(bookingRequestIds[currentIndex]);
    }
    setState(() {});
  }

  Future<List<int>> fetchAssignments() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${widget.token}"
    };

    final response = await http.get(
      Uri.parse('http://104.237.9.211:8007/karuthal/api/v1/bookingrequest/student/43'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> bookingRequests = jsonResponse['result'] ?? jsonResponse;
      return bookingRequests.map((bookingRequest) => bookingRequest['id'] as int).toList();
    } else {
      throw Exception('Failed to load assignments');
    }
  }

  Future<void> getBookingDetails(int bookingRequestId) async {
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${widget.token}"
    };

    var bookingDetails = await http.get(
      Uri.parse('${getBookingRequestsUrl()}/$bookingRequestId'),
      headers: headers,
    );

    if (bookingDetails.statusCode == 200) {
      currentBookingDetails = jsonDecode(bookingDetails.body);
    } else {
      throw Exception('Failed to load booking details: ${bookingDetails.body}');
    }
  }

  Widget getValue(data) {
    String value = data == "false" ? "No" : "Yes";
    return Text(value);
  }

  void nextBooking() {
    if (currentIndex < bookingRequestIds.length - 1) {
      currentIndex++;
      getBookingDetails(bookingRequestIds[currentIndex]);
      setState(() {});
    }
  }

  void previousBooking() {
    if (currentIndex > 0) {
      currentIndex--;
      getBookingDetails(bookingRequestIds[currentIndex]);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentBookingDetails == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
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
        child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Go Back")),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Other UI components remain unchanged

            // Booking Details Header
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              color: Colors.teal,
              width: MediaQuery.sizeOf(context).width,
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    children: [
                      const TextSpan(text: "Booking Details of Booking ID: "),
                      TextSpan(
                          text: "${currentBookingDetails['result']['id']}",
                          style: const TextStyle(fontWeight: FontWeight.bold))
                    ]),
              ),
            ),

            // Pagination Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: previousBooking,
                ),
                Text('Page ${currentIndex + 1} of ${bookingRequestIds.length}'),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: nextBooking,
                ),
              ],
            ),

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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          'Customer Id: ${currentBookingDetails['result']['enrolledByCustomer']['customerId']}'),
                      Text(
                          "Customer name: ${currentBookingDetails['result']['enrolledByCustomer']['registeredUser']['firstName']} ${currentBookingDetails['result']['enrolledByCustomer']['registeredUser']['lastName']}"),
                      Text(
                          "Customer username: ${currentBookingDetails['result']['enrolledByCustomer']['registeredUser']['username']}"),
                      Text(
                          "Job: ${currentBookingDetails['result']['enrolledByCustomer']['job']}"),
                    ],
                  ),
                ),
              ),
            ),


            // Patient list expandable
            const SizedBox(height: 16),

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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // Add ExpansionTile for foldable list
                      ExpansionTile(
                        title: const Text(
                          "View Patient Details",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Column(
                            children: [
                              for (int i = 0;
                                  i <
                                      currentBookingDetails['result']
                                              ['requestedFor']
                                          .length;
                                  i++)
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Table(
                                        columnWidths: const {
                                          0: IntrinsicColumnWidth(),
                                          1: FixedColumnWidth(20),
                                        },
                                        children: [
                                          TableRow(
                                            children: [
                                              const Text("Patient Id "),
                                              const Text(":"),
                                              Text(
                                                  "${currentBookingDetails['result']['requestedFor'][i]['patientId']}"),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              const Text("Patient Name "),
                                              const Text(":"),
                                              Text(
                                                  "${currentBookingDetails['result']['requestedFor'][i]['firstName']} ${currentBookingDetails['result']['requestedFor'][i]['lastName']}"),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              const Text("Patient Age "),
                                              const Text(":"),
                                              Text(
                                                  "${currentBookingDetails['result']['requestedFor'][i]['age']}"),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              const Text("Patient Gender "),
                                              const Text(":"),
                                              Text(
                                                  "${currentBookingDetails['result']['requestedFor'][i]['gender']}"),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              const Text("Health Description "),
                                              const Text(":"),
                                              Text(
                                                  "${currentBookingDetails['result']['requestedFor'][i]['healthDescription']}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
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
                        "Services Requested",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Column(
                        children: [
                          for (int i = 0;
                              i <
                                  currentBookingDetails['result']
                                          ['requestedServices']
                                      .length;
                              i++)
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.all(10),
                                  child: Table(
                                    columnWidths: const {
                                      0: IntrinsicColumnWidth(),
                                      1: FixedColumnWidth(20)
                                    },
                                    children: [
                                      TableRow(children: [
                                        const Text("Service Id "),
                                        const Text(":"),
                                        Text(
                                            "${currentBookingDetails['result']['requestedServices'][i]['id']}")
                                      ]),
                                      TableRow(children: [
                                        const Text("Service Name "),
                                        const Text(":"),
                                        Text(
                                            "${currentBookingDetails['result']['requestedServices'][i]['name']}")
                                      ]),
                                      TableRow(children: [
                                        const Text("Description "),
                                        const Text(":"),
                                        Text(
                                            "${currentBookingDetails['result']['requestedServices'][i]['description']}")
                                      ]),
                                      TableRow(children: [
                                        const Text("Value Added "),
                                        const Text(":"),
                                        getValue(
                                            "${currentBookingDetails['result']['requestedServices'][i]['valueAdded']}"),
                                      ]),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
