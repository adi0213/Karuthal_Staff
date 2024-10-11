import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
//import 'Profile.dart';

class WorkHistory extends StatefulWidget {
  final String token;
  const WorkHistory({super.key,required this.token});
  @override
  State<WorkHistory> createState() => _WorkHistoryState();
}

class _WorkHistoryState extends State<WorkHistory> {
  final TextEditingController _searchName = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String startDate = '';
  String endDate = '';

  Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        helpText: "Select Date",
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.teal, 
                onPrimary: Colors.white, 
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.teal, 
                ),
              ),
            ),
            child: child!
          );
        },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF60CAD8),
        title: const Text(
          'Work History',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          ElevatedButton(onPressed: (){Navigator.pop(context);}, child: const Icon(Icons.arrow_left))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.arrow_left),
                    Text('Go back'),
                  ],
                ),
                textColor: Colors.teal,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchName,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Start Date",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  startDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                  ),
                                )
                              ),
                              IconButton(
                                onPressed: (){
                                  _selectDate(context,(pickedDate){
                                    startDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                  });
                                },
                                icon: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.teal,
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "End Date",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  endDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                  ),
                                )
                              ),
                              IconButton(
                                onPressed: (){
                                  _selectDate(context, (pickedDate){
                                    endDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                  });
                                }, 
                                icon: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.teal,
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Location",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding : const EdgeInsets.only(left: 2,right: 12),
                        child: TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: (){},
                              icon: const Icon(
                                Icons.location_on,
                                color: Colors.teal,
                              )
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal
                  ),
                  onPressed: (){
                    print("Name: ${_searchName.text}");
                    print("Start Date: $startDate");
                    print("End Date: $endDate");
                    print("Location: ${_locationController.text}");
                  }, 
                  child: const Text(
                    "Filter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  )
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
