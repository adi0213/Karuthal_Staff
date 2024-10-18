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
  Map<String, dynamic>? currentBookingDetails;
  List<int> bookingRequestIds = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    print('Initialized StudentAssignedServices with studentId: ${widget.studentId}');
    fetchBookingDetails();
  }

  void fetchBookingDetails() async {
    try {
      bookingRequestIds = await fetchAssignments();
      print("Fetched Booking Request IDs: $bookingRequestIds");
      if (bookingRequestIds.isNotEmpty) {
        await getBookingDetails(bookingRequestIds[currentIndex]);
      }
    } catch (e) {
      print("Error: $e");
    }
    print('return fetchBookingDetails');
  }

  Future<List<int>> fetchAssignments() async {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      print('Fetching from: ${getBookingRequestsUrl()}/student/${widget.studentId}');
      final response = await http.get(
        Uri.parse('${getBookingRequestsUrl()}/student/${widget.studentId}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print('---- jsonResponse: $jsonResponse');

        if (jsonResponse['status'] == 200) {
          List<dynamic> bookingRequests = jsonResponse['result'];
          List<int> bookingRequestIds = bookingRequests
              .map((bookingRequest) => bookingRequest['id'] as int)
              .toList();
          print('Booking request IDs: $bookingRequestIds');
          return bookingRequestIds;
        } else {
          throw Exception('Failed to retrieve booking requests: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load assignments');
      }
    }

  Future<void> getBookingDetails(int bookingRequestId) async {
    print('---- calling getBookingDetails with ID: $bookingRequestId');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${widget.token}"
    };

    try {
      final response = await http.get(
        Uri.parse('${getBookingRequestsUrl()}/$bookingRequestId'),
        headers: headers,
      );

     
      if (response.statusCode == 200) {
        final bookingDetailsResponse = jsonDecode(response.body);
        print('---- bookingDetails: ${bookingDetailsResponse['result']}');

        setState(() {
          // Directly assign the result to currentBookingDetails
          currentBookingDetails = bookingDetailsResponse['result'];
        });
      } else {
        // Handle non-200 responses
        final errorDetails = jsonDecode(response.body);
        throw Exception('Failed to load booking details: ${errorDetails['message']}');
      }
    } catch (e) {
      // Handle exceptions (e.g., network issues)
      print('Error fetching booking details: $e');
      throw Exception('An error occurred while fetching booking details: $e');
    }
  }


  Widget getValue(dynamic data) {
    if (data is bool) {
      return Text(data ? "Yes" : "No");
    } else if (data is String) {
      return Text(data);
    } else {
      return const Text("Unknown");
    }
  }


  void nextBooking() {
    if (currentIndex < bookingRequestIds.length - 1) {
      currentIndex++;
      getBookingDetails(bookingRequestIds[currentIndex]);
    }
  }

  void previousBooking() {
    if (currentIndex > 0) {
      currentIndex--;
      getBookingDetails(bookingRequestIds[currentIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentBookingDetails == null) {
      return const Center(
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
          child: const Text("Go Back"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Details Header
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              color: Colors.teal,
              width: MediaQuery.of(context).size.width,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  children: [
                    const TextSpan(text: "Booking Details of Booking ID: "),
                    TextSpan(
                      text: currentBookingDetails?['id'] != null
                          ? "${currentBookingDetails!['id']}"
                          : "N/A",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
            const SizedBox(height: 16),
            buildCustomerDetailsCard(),

            
            // Patient list expandable
            const SizedBox(height: 16),
            buildPatientList(),

            const SizedBox(height: 16),
            // Services required card
            buildServicesRequestedCard(),
          ],
        ),
      ),
    );
  }

 Widget buildCustomerDetailsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Customer details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Customer Id: ${currentBookingDetails!['enrolledByCustomer']['customerId']}',
              ),
              Text(
                "Customer name: ${currentBookingDetails!['enrolledByCustomer']['registeredUser']['firstName']} ${currentBookingDetails!['enrolledByCustomer']['registeredUser']['lastName']}",
              ),
              Text(
                "Customer username: ${currentBookingDetails!['enrolledByCustomer']['registeredUser']['username']}",
              ),
              Text(
                "Job: ${currentBookingDetails!['enrolledByCustomer']['job']}",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPatientList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: MediaQuery.of(context).size.width,
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
              ExpansionTile(
                title: const Text(
                  "View Patient Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                children: [
                  for (int i = 0;
                      i < currentBookingDetails!['requestedFor'].length;
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
                                    "${currentBookingDetails!['requestedFor'][i]['patientId']}",
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text("Patient Name "),
                                  const Text(":"),
                                  Text(
                                    "${currentBookingDetails!['requestedFor'][i]['firstName']} ${currentBookingDetails!['requestedFor'][i]['lastName']}",
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text("Patient Age "),
                                  const Text(":"),
                                  Text(
                                    "${currentBookingDetails!['requestedFor'][i]['age']}",
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text("Patient Gender "),
                                  const Text(":"),
                                  Text(
                                    "${currentBookingDetails!['requestedFor'][i]['gender']}",
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text("Health Description "),
                                  const Text(":"),
                                  Text(
                                    "${currentBookingDetails!['requestedFor'][i]['healthDescription']}",
                                  ),
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
        ),
      ),
    );
  }

  Widget buildServicesRequestedCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Services Requested",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              for (int i = 0;
                  i < currentBookingDetails!['requestedServices'].length;
                  i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text(
                      "${i + 1}. ${currentBookingDetails!['requestedServices'][i]['name']}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Table(
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FixedColumnWidth(20),
                      },
                      children: [
                        TableRow(
                          children: [
                            const Text("Description"),
                            const Text(":"),
                            Text(
                              "${currentBookingDetails!['requestedServices'][i]['description']}",
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text("Value-added"),
                            const Text(":"),
                            getValue(currentBookingDetails!
                                ['requestedServices'][i]['valueAdded']),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

}
