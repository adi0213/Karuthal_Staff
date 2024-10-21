import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'common/ManagerDrawer.dart';
import 'common/bookingrequest_cards.dart';
import 'common/patient.dart';
import 'common/student.dart';
import 'global_api_constants.dart';

class AssignService extends StatefulWidget {
  final String token;
  final int managerId;
  final Map<String, dynamic> details;
  const AssignService(
      {super.key,
      required this.token,
      required this.managerId,
      required this.details});

  State<AssignService> createState() => _AssignServiceState();
}

class _AssignServiceState extends State<AssignService> {
  Map<String, dynamic>? currentBookingDetails;
  List<int> bookingRequestIds = [];
  int currentIndex = 0;

  List<dynamic> searchResults = [];
  List<dynamic> selectedStudents = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPendingBookingRequests();
  }

  Future<void> fetchPendingBookingRequests() async {
    List<int>? ids = await getPendingBookingRequests();
    if (ids != null && ids.isNotEmpty) {
      setState(() {
        bookingRequestIds = ids;
      });
      getBookingDetails(
          bookingRequestIds[0]); // Fetch the first booking details
    }
  }

  void nextBooking() {
    if (currentIndex < bookingRequestIds.length - 1) {
      setState(() {
        currentIndex++;
      });
      getBookingDetails(bookingRequestIds[currentIndex]);
    }
  }

  void previousBooking() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      getBookingDetails(bookingRequestIds[currentIndex]);
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
          print('currentBookingDetails: $currentBookingDetails');
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

  Future<List<int>?> getPendingBookingRequests() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };

    final response = await http.get(
      Uri.parse('${getBookingRequestsUrl()}/status/pending'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 200) {
        List<dynamic> bookingRequests = jsonResponse['result'];
        List<int> bookingRequestIds = bookingRequests
            .map((bookingRequest) => bookingRequest['id'] as int)
            .toList();
        print('Booking request IDs: $bookingRequestIds');
        return bookingRequestIds;
      } else {
        throw Exception(
            'Failed to retrieve booking requests: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load assignments');
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
      drawer: ManagerDrawer(
        details: widget.details,
        token: widget.details['authtoken'] ?? '',
        managerId: widget.details['managerId'] ?? 0,
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
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to the dashboard
                    },
                    child: const Text(
                      'Go Back to Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

            // Patient list and services required card side by side
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Even spacing
              children: [
                Expanded(
                  child: buildPatientList(
                      currentBookingDetails!['requestedFor'], context),
                ),
                const SizedBox(width: 16), // Spacing between the two cards
                Expanded(
                  child: buildServicesRequestedCard(
                      currentBookingDetails!['requestedServices'], context),
                ),
              ],
            ),

        // Detailed Search Section
const SizedBox(height: 16),
Container(
  width: MediaQuery.of(context).size.width * 0.8,
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  margin: const EdgeInsets.only(left: 16.0), // Add left margin here
  decoration: BoxDecoration(
  
    borderRadius: BorderRadius.circular(12), // Rounded corners
    border: Border.all(color: Colors.teal), // Border color
    boxShadow: [
      BoxShadow(
        color: Colors.black12, // Shadow color
        blurRadius: 8.0, // Spread of shadow
        offset: Offset(0, 2), // Position of shadow
      ),
    ],
  ),
  child: Column(
    // Use Column to allow stacking the search fields and results
    children: [
        Container(
          padding: const EdgeInsets.all(16.0), // Add padding for spacing
          decoration: BoxDecoration(
            color: Colors.teal, // Set background color to teal
            borderRadius: BorderRadius.circular(12), // Round edges
          ),
          child: const Text(
            "Search Available Students", // Header for the search section
            style: TextStyle(
              fontSize: 24,
              color: Colors.white, // Text color
              fontWeight: FontWeight.bold, // Bold text
            ),
          ),
        ),

      const SizedBox(height: 16), // Spacing between header and input fields
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space items evenly
        children: [
          Expanded(
            // Wrap each TextField in an Expanded widget to occupy available space
            child: TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Focus border color
                ),
              ),
              style: const TextStyle(color: Colors.white), // Change text color to white
              cursorColor: Colors.white, // Change cursor color to white
            ),
          ),
          const SizedBox(width: 8), // Spacing between fields
          Expanded(
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Focus border color
                ),
              ),
              style: const TextStyle(color: Colors.white), // Change text color to white
              cursorColor: Colors.white, // Change cursor color to white
            ),
          ),
          const SizedBox(width: 8), // Spacing between fields
          ElevatedButton(
            onPressed: searchStudents,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal, // Button text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded button
              ),
            ),
            child: const Text('Search'),
          ),
        ],
      ),
      // Display search results
      const SizedBox(height: 16),
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final student = searchResults[index];
                return CheckboxListTile(
                  title: Text(
                    '${student.firstName} ${student.lastName}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    student.email,
                    style: const TextStyle(color: Colors.black),
                  ),
                  value: selectedStudents.contains(student.studentId), // Check if student ID is selected
                  onChanged: (isSelected) {
                    setState(() {
                      if (isSelected == true) {
                        selectedStudents.add(student.studentId); // Add student ID to selected list
                      } else {
                        selectedStudents.remove(student.studentId); // Remove student ID from selected list
                      }
                    });
                  },
                );
              },
            ),
    ],
  ),
),


            const SizedBox(height: 10),

            Center(
              // Center the button
              child: ElevatedButton(
                onPressed: () {
                  submitSelectedStudents();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12), // Increase padding for more prominence
                  backgroundColor: Colors.teal, // Set background color
                  foregroundColor: Colors.white, // Set text color
                  elevation: 5, // Add shadow for depth
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18, // Increase font size for better visibility
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
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

  Future<void> searchStudents() async {
    setState(() {
      isLoading = true;
    });

    // Prepare criteria
    final criteria = {
      'lastName': lastNameController.text,
      'email': emailController.text,
    };

    try {
      final response = await http.get(
        Uri.parse(getStudentUpdateUrl()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 200) {
          List<dynamic> students = jsonResponse['result'];
          setState(() {
            searchResults = students.map((student) {
              return Student.fromJson(student);
            }).toList();
          });
        } else {
          throw Exception(
              'Failed to load students: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load students: ${response.body}');
      }
    } catch (e) {
      print('Error searching students: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void submitSelectedStudents() {
    // Handle the submission of selected students
    // For example, send them to another screen or process them
    print('Selected Students: $selectedStudents');
  }
}
