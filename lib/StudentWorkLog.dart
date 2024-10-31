import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'StudentDashboard.dart';
import 'StudentDrawer.dart';
import 'global_api_constants.dart'; // Import intl package for date formatting

class WorkLogForm extends StatefulWidget {
  final Map<String, dynamic> details;
  final String token;
  final int studentId;

  const WorkLogForm({
    Key? key,
    required this.token,
    required this.studentId,
    required this.details,
  }) : super(key: key);

  @override
  _WorkLogFormState createState() => _WorkLogFormState();
}

class _WorkLogFormState extends State<WorkLogForm> {
  final _formKey = GlobalKey<FormState>();
  String _workDescription = '';
  List<int> _selectedBookingRequests = [];
  DateTime _workStartTime =
      DateTime.now(); // Default to current time for clock-in
  List<dynamic> _bookingRequests = [];
  Map<String, dynamic>? _selectedBookingDetails;

  @override
  void initState() {
    super.initState();
    _fetchBookingRequests();

    if (widget.details.isNotEmpty) {
      _workDescription = widget.details['workDescription'] ?? '';
      _workStartTime = DateTime.parse(
          widget.details['workStartTime'] ?? DateTime.now().toIso8601String());

      if (widget.details['bookingRequests'] != null) {
        _selectedBookingRequests = List<int>.from(
            widget.details['bookingRequests'].map((b) => b['id']));
      }
    }
  }

  Future<void> _fetchBookingRequests() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };
    final response = await http.get(
      Uri.parse('${getBRequestsForStudentUrl()}/${widget.studentId}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 200) {
        setState(() {
          _bookingRequests = jsonResponse['result'] ?? [];
          if (_bookingRequests.isNotEmpty) {
            _selectedBookingRequests.add(_bookingRequests.first['id']);
            _selectedBookingDetails = _bookingRequests.first;
          }
        });
      } else {
        throw Exception(
            'Failed to retrieve booking requests: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load booking requests');
    }
  }

  void _submitForm() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Prepare the work log data
      final workLogData = {
        "student": {"studentId": widget.studentId},
        "bookingRequest": {"id": _selectedBookingRequests.first},
        "workDescription": _workDescription,
        "workStartTime": _workStartTime.toIso8601String(),
      };

      print('Submitting: $workLogData');

      // Use http.post to submit the work log
      final response = await http.post(
        Uri.parse(
            '${getWorkLogUrl()}/create'), // Ensure correct endpoint and method
        headers: headers,
        body: jsonEncode(workLogData), // Convert workLogData to JSON
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 200) {
          if (jsonResponse['status'] == 200) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StudentDashboard(
                  details: widget.details,
                ),
              ),
            );
          }
        } else {
          throw Exception(
              'Failed to create work log: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to create work log. Status code: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clock In - Work Log'),
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Booking Request:'),
              DropdownButtonFormField<int>(
                isExpanded: true,
                value: _selectedBookingRequests.isNotEmpty
                    ? _selectedBookingRequests.first
                    : null,
                items: _bookingRequests.map((booking) {
                  return DropdownMenuItem<int>(
                    value: booking['id'],
                    child: Text(
                        'Booking ID: ${booking['id']} - ${booking['description']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBookingRequests = value != null ? [value] : [];
                    _selectedBookingDetails = _bookingRequests
                        .firstWhere((booking) => booking['id'] == value);
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              if (_selectedBookingDetails != null) ...[
                Text(
                  'Enrolled By: ${_selectedBookingDetails!['enrolledByCustomer']['firstName']} '
                  '${_selectedBookingDetails!['enrolledByCustomer']['lastName']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Requested For:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                for (var patient in _selectedBookingDetails!['requestedFor'])
                  Text(
                    '${patient['firstName']} ${patient['lastName']}',
                    style: TextStyle(fontSize: 16),
                  ),
                SizedBox(height: 20),
              ],
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Work Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) {
                  _workDescription = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Start Work'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
