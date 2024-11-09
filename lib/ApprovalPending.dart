import 'dart:convert';

import 'package:flutter/material.dart';
import 'global_api_constants.dart';
import 'package:http/http.dart' as http;

class ApprovalPending extends StatefulWidget {
  final String token;
  const ApprovalPending({super.key, required this.token});

  @override
  State<ApprovalPending> createState() => _ApprovalPendingState();
}

class _ApprovalPendingState extends State<ApprovalPending> {
  late Future<List> pendingRequestsList;
  List pendingRequests = [];

  Future<List> _fetchPendingApprovals() async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };
      final pendingRequestDetails = await http.get(
        Uri.parse(getPendingRoleRequest()),
        headers: headers,
      );

      var pendingRequestsDetailsList = jsonDecode(pendingRequestDetails.body);
      return pendingRequestsDetailsList['result'];
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<void> updateRole(int id, String status, String comment) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };
      final Map<String, dynamic> body = {
        "id": id,
        "status": status,
        "comment": comment
      };
      final response = await http.put(Uri.parse(updatePendingRoleRequest()),
          headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        pendingRequestsList = _fetchPendingApprovals();
        setState(() {});
      } else {
        print("Exited with ${response.statusCode}");
      }
    } catch (e) {
      // print("Except $e");
    }
  }

  void initState() {
    super.initState();
    pendingRequestsList = _fetchPendingApprovals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF60CAD8),
        title: const Text(
          'Pending Requests for Approval',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      body: Center(child: getList()),
    );
  }

  Widget getList() {
    return FutureBuilder<List>(
      future: pendingRequestsList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          pendingRequests = snapshot.data ?? [];
          print("Hello $pendingRequests");
          if (pendingRequests.isEmpty) {
            return const Center(child: Text("No Pending Requests"));
          }
          return ListView.builder(
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              final pendingRequest = pendingRequests[index];
              return approvalCard(pendingRequest);
            },
          );
        }
        return Center(child: Text("No data available"));
      },
    );
  }

  Widget approvalCard(Map pendingRequest) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${pendingRequest['requestedByUser']['username']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text('Role: ${pendingRequest['requestedRole']}'),
            Text('E-Mail: ${pendingRequest['requestedByUser']['email']}'),
            Text('Status: ${pendingRequest['status']}'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController roleUpdateController =
                                  TextEditingController();
                              return AlertDialog(
                                title: Text(
                                    "Approve  ${pendingRequest['requestedByUser']['username']} as ${pendingRequest['requestedRole']}"),
                                content: TextField(
                                  controller: roleUpdateController,
                                  decoration: const InputDecoration(
                                      hintText: "Comments"),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        var comment =
                                            roleUpdateController.text == ""
                                                ? "Request has been approved"
                                                : roleUpdateController.text;
                                        updateRole(pendingRequest['id'],
                                            "APPROVED", comment);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Approve")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel")),
                                ],
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Approve',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController roleUpdateController =
                                  TextEditingController();
                              return AlertDialog(
                                title: Text(
                                    "Approve  ${pendingRequest['requestedByUser']['username']} as ${pendingRequest['requestedRole']}"),
                                content: TextField(
                                  controller: roleUpdateController,
                                  decoration: const InputDecoration(
                                      hintText: "Comments"),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        var comment =
                                            roleUpdateController.text == ""
                                                ? "Request has been rejected"
                                                : roleUpdateController.text;
                                        updateRole(pendingRequest['id'],
                                            "REJECTED", comment);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Reject")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel")),
                                ],
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Reject',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
