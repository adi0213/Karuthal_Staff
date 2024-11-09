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

  const StudentAssignedServices({
    super.key,
    required this.token,
    required this.studentId,
    required this.details,
  });

  @override
  State<StudentAssignedServices> createState() =>
      _StudentAssignedServicesState();
}

class _StudentAssignedServicesState extends State<StudentAssignedServices> {
  Map<String, dynamic>? currentBookingDetails;
  List<int> bookingRequestIds = [];
  int currentIndex = 0;
  bool _noRecords = false; // Flag for no records found
  bool _hasError = false; // Flag for any errors encountered

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
  }

  void fetchBookingDetails() async {
    try {
      bookingRequestIds = await fetchAssignments();

      if (bookingRequestIds.isNotEmpty) {
        await getBookingDetails(bookingRequestIds[currentIndex]);
      } else {
        setState(() {
          _noRecords = true; // Set flag if no bookings are found
        });
      }
    } catch (e) {
      print("Error fetching booking details: $e");
      setState(() {
        _hasError = true;
      });
    }
  }

  Future<List<int>> fetchAssignments() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };

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
        print("Server error: ${jsonResponse['message']}");
        setState(() {
          _noRecords = true; // No records found
        });
        return [];
      }
    } else {
      print("Failed to load assignments: ${response.reasonPhrase}");
      setState(() {
        _hasError = true;
      });
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
        setState(() {
          currentBookingDetails = bookingDetailsResponse['result'];
          _hasError = false;
        });
      } else {
        final errorDetails = jsonDecode(response.body);
        print("Error loading booking details: ${errorDetails['message']}");
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      print("Network or unexpected error occurred: $e");
      setState(() {
        _hasError = true;
      });
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
        // Header
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.teal,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    children: [
                      const TextSpan(text: "Booking Details"),
                      if (currentBookingDetails != null &&
                          currentBookingDetails?['id'] != null)
                        TextSpan(
                          text: " of Booking ID: ${currentBookingDetails!['id']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
        
        const SizedBox(height: 16),

        // Conditional content
        Expanded(
          child: Center(
            child: _hasError
                ? const Text("An error occurred. Please try again.")
                : _noRecords
                    ? const Text("No booking requests found.")
                    : currentBookingDetails == null
                        ? const CircularProgressIndicator()
                        : SingleChildScrollView(
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

                                // Display booking details
                                buildCustomerDetailsCard(
                                    currentBookingDetails!['enrolledByCustomer'],
                                    context),
                                const SizedBox(height: 16),
                                buildPatientList(
                                    currentBookingDetails!['requestedFor'],
                                    context),
                                const SizedBox(height: 16),
                                buildServicesRequestedCard(
                                    currentBookingDetails!['requestedServices'],
                                    context),
                              ],
                            ),
                          ),
          ),
        ),
      ],
    ),
  );
}

}
