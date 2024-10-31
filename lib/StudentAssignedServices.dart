import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'StudentDrawer.dart';
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
      } else {
        setState(() {
          currentBookingDetails = null;
        });
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
          List<dynamic>? bookingRequests = jsonResponse['result'];

          // Check if bookingRequests is null or empty
          if (bookingRequests == null || bookingRequests.isEmpty) {
            print('No booking requests available');
            return []; // Return an empty list when there are no results
          }

          List<int> bookingRequestIds = bookingRequests
              .map((bookingRequest) => bookingRequest['id'] as int)
              .toList();

          return bookingRequestIds;

        } else {
          throw Exception(
              'Failed to retrieve booking requests: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load assignments');
      }
    } catch (e) {
      print('Error fetching assignments: $e');
      return []; // Return an empty list in case of an error
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
        final errorDetails = jsonDecode(response.body);
        throw Exception(
            'Failed to load booking details: ${errorDetails['message']}');
      }
    } catch (e) {
      print('Error fetching booking details: $e');
      throw Exception('An error occurred while fetching booking details: $e');
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
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
      ],
    ),
    drawer: StudentDrawer(
      details: widget.details,
      token: widget.details['authtoken'] ?? '',
      studentId: widget.details['studentId'] ?? 0,
    ),
    body: Column(
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
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                        children: [
                          const TextSpan(text: "Booking Details: "),
                          TextSpan(
                            text: (currentBookingDetails != null && currentBookingDetails!['id'] != null)
                                ? currentBookingDetails!['id'].toString()
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

        if (bookingRequestIds.isEmpty && currentBookingDetails == null)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No booking requests available.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        else if (currentBookingDetails == null)
          const Center(child: CircularProgressIndicator())
        else
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pagination Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: previousBooking,
                      ),
                      Text(
                        'Page ${currentIndex + 1} of ${bookingRequestIds.length}',
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: nextBooking,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  buildCustomerDetailsCard(
                      currentBookingDetails!['enrolledByCustomer'], context),

                  const SizedBox(height: 16),
                  buildPatientList(
                      currentBookingDetails!['requestedFor'], context),

                  const SizedBox(height: 16),
                  buildServicesRequestedCard(
                      currentBookingDetails!['requestedServices'], context),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}


}
