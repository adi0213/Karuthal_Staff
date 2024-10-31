
import 'package:flutter/material.dart';

// Helper function for value rendering (ensure this is in scope)
Widget getValue(dynamic value) {
  return Text(value?.toString() ?? "N/A");
}

// Widget to display customer details
Widget buildCustomerDetailsCard(Map<String, dynamic>? customerDetails, BuildContext context) {
  // Check if customerDetails is null
  if (customerDetails == null || customerDetails['registeredUser'] == null) {
    return const Center(
      child: Text("Customer details not available."),
    );
  }

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
            Text('Customer Id: ${customerDetails['customerId'] ?? 'N/A'}'),
            Text(
              "Customer name: ${customerDetails['registeredUser']['firstName'] ?? 'N/A'} "
              "${customerDetails['registeredUser']['lastName'] ?? 'N/A'}",
            ),
            Text("Customer username: ${customerDetails['registeredUser']['username'] ?? 'N/A'}"),
            Text("Job: ${customerDetails['job'] ?? 'N/A'}"),
          ],
        ),
      ),
    ),
  );
}

// Widget to display the patient list
Widget buildPatientList(List<dynamic>? patientList, BuildContext context) {
  if (patientList == null || patientList.isEmpty) {
    return const Center(
      child: Text("No patients available."),
    );
  }

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
                for (int i = 0; i < patientList.length; i++)
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
                                Text("${patientList[i]['patientId'] ?? 'N/A'}"),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("Patient Name "),
                                const Text(":"),
                                Text("${patientList[i]['firstName'] ?? 'N/A'} ${patientList[i]['lastName'] ?? 'N/A'}"),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("Patient Age "),
                                const Text(":"),
                                Text("${patientList[i]['age'] ?? 'N/A'}"),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("Patient Gender "),
                                const Text(":"),
                                Text("${patientList[i]['gender'] ?? 'N/A'}"),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("Health Description "),
                                const Text(":"),
                                Text("${patientList[i]['healthDescription'] ?? 'N/A'}"),
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

// Widget to display services requested
Widget buildServicesRequestedCard(List<dynamic> requestedServices, BuildContext context) {
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
            ExpansionTile(
              title: const Text(
                "View Services Requested",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: [
                for (int i = 0; i < requestedServices.length; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Text(
                        "${i + 1}. ${requestedServices[i]['name']}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                              Text("${requestedServices[i]['description']}"),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text("Value-added"),
                              const Text(":"),
                              getValue(requestedServices[i]['valueAdded']),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
