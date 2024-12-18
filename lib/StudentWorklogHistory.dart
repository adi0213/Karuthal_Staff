import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'global_api_constants.dart';

class StudentWorkLogHistory extends StatefulWidget {
  final String token;
  final int studentId;
  final Map<String, dynamic> details;

  const StudentWorkLogHistory({
    Key? key,
    required this.token,
    required this.studentId,
    required this.details,
  }) : super(key: key);

  @override
  _StudentWorkLogHistoryState createState() => _StudentWorkLogHistoryState();
}

class _StudentWorkLogHistoryState extends State<StudentWorkLogHistory> {
  List<dynamic> _workLogs = [];
  bool _noRecords = false;
  int _currentPage = 0; // Keep track of the current page
  final int _pageSize = 5; // Define the number of entries per page

  @override
  void initState() {
    super.initState();
    _fetchWorkLogs();
  }

  Future<void> _fetchWorkLogs() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };
    final uri = Uri.parse('${getWorkLogUrl()}/student/${widget.studentId}');
    //print('Fetching work logs from: $uri');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 200) {
        setState(() {
          _workLogs = jsonResponse['result'];
        });
      } else {
        print("JSR: ${jsonResponse['message']}");
        setState(() {
          _noRecords = true;
        });
        //throw Exception('Failed to retrieve work logs: ${jsonResponse['message']}');
      }
    } else {
      print("Failed to load work logs");
      //throw Exception('Failed to load work logs');
    }
  }

  // Method to get the logs for the current page
  List<dynamic> getCurrentPageLogs() {
    int startIndex = _currentPage * _pageSize;
    int endIndex = startIndex + _pageSize;
    return _workLogs.sublist(
        startIndex, endIndex > _workLogs.length ? _workLogs.length : endIndex);
  }

  void _nextPage() {
    if ((_currentPage + 1) * _pageSize < _workLogs.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Work Log History',
        ),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
        backgroundColor: Color(0xFF60CAD8),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _workLogs.isEmpty
              ? (_noRecords
                  ? Center(child: Text("No Worklogs Found"))
                  : Center(child: CircularProgressIndicator()))
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.teal,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Page ${_currentPage + 1} of ${(_workLogs.length / _pageSize).ceil()}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: getCurrentPageLogs().length,
                        itemBuilder: (context, index) {
                          final workLog = getCurrentPageLogs()[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text('Log ID: ${workLog['logId']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Description: ${workLog['workDescription']}'),
                                  Text(
                                      'Start Time: ${workLog['workStartTime']}'),
                                  Text('End Time: ${workLog['workEndTime']}'),
                                  Text('Duration: ${workLog['duration']}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left),
                          onPressed: _previousPage,
                        ),
                        Text(
                            'Page ${_currentPage + 1} of ${(_workLogs.length / _pageSize).ceil()}'),
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: _nextPage,
                        ),
                      ],
                    ),
                  ],
                )),
    );
  }
}
