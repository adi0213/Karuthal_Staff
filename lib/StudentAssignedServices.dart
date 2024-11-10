import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common/bookingrequest_cards.dart';
import 'global_api_constants.dart';

class StudentAssignedServices extends StatefulWidget {
  final String token;
  final int studentId;
  final Map<String, dynamic> details;
  const StudentAssignedServices(
      {super.key,
      required this.token,
      required this.studentId,
      required this.details});

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
    print(
        'Initialized StudentAssignedServices with studentId: ${widget.studentId}');
    fetchBookingDetails();
  }

  void fetchBookingDetails() async {
    try {
      bookingRequestIds = await fetchAssignments();

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

    try {
      final response = await http.get(
        Uri.parse('${getBookingRequestsUrl()}/student/${widget.studentId}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 200) {
          List<dynamic> bookingRequests = jsonResponse['result'];
          List<int> bookingRequestIds = bookingRequests
              .map((bookingRequest) => bookingRequest['id'] as int)
              .toList();
          return bookingRequestIds;
        } else {
          throw Exception('Failed to retrieve booking requests: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load assignments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }


  Future<void> getBookingDetails(int bookingRequestId) async {
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
        //final errorDetails = jsonDecode(response.body);
        //throw Exception('Failed to load booking details: ${errorDetails['message']}');
      }
    } catch (e) {
      // Handle exceptions (e.g., network issues)
      //print('Error fetching booking details: $e');
      //throw Exception('An error occurred while fetching booking details: $e');
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
    // If currentBookingDetails is null, display a message indicating no details are available
    if (currentBookingDetails == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Booking Details'),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
          ),
        ),
        body: Center(
          child: Text(
            'No booking requests found for this student.',
            style: TextStyle(fontSize: 18, color: Colors.teal),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Booking Details'),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.teal,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        children: [
                          const TextSpan(
                              text: "Booking Details of Booking ID: "),
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
                ],
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
            buildCustomerDetailsCard(
                currentBookingDetails!['enrolledByCustomer'], context),

            // Patient list expandable
            const SizedBox(height: 16),
            buildPatientList(currentBookingDetails!['requestedFor'], context),

            const SizedBox(height: 16),
            // Services required card
            buildServicesRequestedCard(
                currentBookingDetails!['requestedServices'], context),
          ],
        ),
      ),
    );
  }
}
