import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'StudentDashboard.dart';
import 'StudentDrawer.dart';
import 'global_api_constants.dart';

class CompleteWorkLogForm extends StatefulWidget {
  final Map<String, dynamic> details;
  final String token;
  final int studentId;

  const CompleteWorkLogForm({
    Key? key,
    required this.token,
    required this.studentId,
    required this.details,
  }) : super(key: key);

  @override
  _CompleteWorkLogFormState createState() => _CompleteWorkLogFormState();
}

class _CompleteWorkLogFormState extends State<CompleteWorkLogForm> {
  final _formKey = GlobalKey<FormState>();
  String _workDescription = '';
  DateTime? _workStartTime;
  Map<String, dynamic>? _workLogDetails;

  @override
  void initState() {
    super.initState();
    _fetchPendingWorkLog();
  }

  Future<void> _fetchPendingWorkLog() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };
    final uri = Uri.parse('${getUnifinishedWorkLogUrl()}/${widget.studentId}');

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 200) {
          setState(() {
            _workLogDetails = jsonResponse['result'];
            
            // Handle null or missing 'result' case
            if (_workLogDetails != null) {
              _workDescription = _workLogDetails!['workDescription'] ?? 'No description available';
              _workStartTime = _workLogDetails!['workStartTime'] != null
                  ? DateTime.parse(_workLogDetails!['workStartTime'])
                  : null;
            } else {
              // If result is null, set default values or handle accordingly
              _workDescription = 'No pending work log';
              _workStartTime = null;
            }
          });
        }
      } 
    } catch (e) {
      // Handle other potential exceptions, such as network issues
      print('Error fetching work log: $e');
          }
  }


  void _completeWork() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_workLogDetails != null && _workLogDetails!.containsKey('logId')) {
        int logId = _workLogDetails!['logId'];
        print('Work log ID: $logId');
        final response = await http.put(
          Uri.parse('${getWorkLogUrl()}/complete/$logId'),
          headers: headers,
        );

        // Check if the response is successful
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);

          if (jsonResponse['status'] == 200) {
            Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDashboard(
                            details: widget.details,
                          ),
                        ),
                      );
          } else {
            throw Exception('Failed to complete work log: ${jsonResponse['message']}');
          }
        } else {
          throw Exception('Failed to complete work log. Status code: ${response.statusCode}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Clock out - Complete work log'),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
          ),
        ),
      drawer: StudentDrawer(
        details: widget.details,
        token: widget.token,
        studentId: widget.studentId,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_workLogDetails != null) ...[
                Text(
                  'Work Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_workDescription),
                SizedBox(height: 10),
                Text(
                  'Start Time: ${_workStartTime != null ? _workStartTime!.toLocal().toString() : ''}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _completeWork,
                  child: Text('Complete Work'),
                ),
              ] else ...[
                
                Center(
                  child: Text(
                    'No pending work log found.',
                    style: TextStyle(fontSize: 18, color: Colors.teal),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
