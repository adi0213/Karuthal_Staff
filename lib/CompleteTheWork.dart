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
    //print('Fetching pending work log from: $uri');
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 200) {
        setState(() {
          _workLogDetails = jsonResponse['result'];
          //print('_workLogDetails: $_workLogDetails');
          if (_workLogDetails != null) {
            _workDescription = _workLogDetails!['workDescription'] ?? '';
            _workStartTime = DateTime.parse(_workLogDetails!['workStartTime']);
          }
        });
      } else {
        throw Exception(
            'Failed to retrieve work log: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load work log');
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
            throw Exception(
                'Failed to complete work log: ${jsonResponse['message']}');
          }
        } else {
          throw Exception(
              'Failed to complete work log. Status code: ${response.statusCode}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Work Log'),
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
                Text('No pending work log found.'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
