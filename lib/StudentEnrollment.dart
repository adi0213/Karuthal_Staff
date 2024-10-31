import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'StudentDashboard.dart';
import 'common/formfields.dart';
import 'common/personalizedService.dart';
import 'global_api_constants.dart';

class StudentSelfEnrollment extends StatefulWidget {
  final Map<String, dynamic> details;
  final int studentId;
  final String token;
  final String email;

  StudentSelfEnrollment({
    super.key,
    required this.details,
  })  : studentId = details['studentId'] ?? 0,
        token = details['authtoken'] ?? '',
        email = details['email'] ?? '';

  @override
  _StudentSelfEnrollmentState createState() => _StudentSelfEnrollmentState();
}

class _StudentSelfEnrollmentState extends State<StudentSelfEnrollment> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _completionYearController = TextEditingController();

  Gender? _selectedGender;
  List<PersonalizedService> _selectedServices = [];
  List<PersonalizedService> _availableServices = [];

  @override
  void initState() {
    super.initState();
    _initializeFormData();
     _fetchStudentDetails();
    _fetchAvailableServices();
  }

  void _initializeFormData() {
    _firstNameController.text = widget.details['firstName'] ?? '';
    _lastNameController.text = widget.details['lastName'] ?? '';
    _ageController.text = widget.details['age']?.toString() ?? '';
    _courseController.text = widget.details['course'] ?? '';
    _completionYearController.text = widget.details['completionYear']?.toString() ?? '';
    _selectedGender = Gender.values.firstWhere(
        (gender) => gender.toString().split('.').last.toUpperCase() == widget.details['gender'],
        orElse: () => Gender.MALE);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final studentData = _getStudentData();
      print('Payload to be sent: ${jsonEncode(studentData)}');
      try {
        final response = await http.put(
          Uri.parse('${getStudentUpdateUrl()}${widget.studentId}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: jsonEncode(studentData),
        );

        _handleResponse(response);
      } catch (e) {
        _showSnackbar('Error submitting form: $e');
      }
    }
  }
Future<void> _fetchStudentDetails() async {
  try {
    final response = await http.get(
      Uri.parse('${getStudentUpdateUrl()}${widget.studentId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final Map<String, dynamic> studentData = responseData['result'];

      setState(() {
        // Populate the fields from the API response
        _firstNameController.text = studentData['firstName'] ?? '';
        _lastNameController.text = studentData['lastName'] ?? '';
        _ageController.text = studentData['age']?.toString() ?? '';  
        _courseController.text = studentData['course'] ?? '';
        _completionYearController.text = studentData['completionYear'] ?? '';
        
        // Populate gender
        _selectedGender = Gender.values.firstWhere(
          (gender) => gender.toString().split('.').last.toUpperCase() == studentData['gender'],
          orElse: () => Gender.MALE,
        );

        // Populate selected services
        if (studentData['services'] != null) {
          _selectedServices = (studentData['services'] as List)
              .map((serviceJson) => PersonalizedService.fromJson(serviceJson))
              .toList();
        }

      });
    } else {
      _showSnackbar('Failed to load student details: ${response.statusCode}');
    }
  } catch (e) {
    _showSnackbar('Error loading student details: $e');
  }
}


  Future<void> _fetchAvailableServices() async {
    try {
      final response = await http.get(
        Uri.parse(getServicesUrl()),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> servicesList = responseData['result'];
        setState(() {
          _availableServices = servicesList
              .map((serviceJson) => PersonalizedService.fromJson(serviceJson))
              .toList();
        });
      } else {
        _showSnackbar('Failed to load services: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('Error loading services: $e');
    }
  }


  Map<String, dynamic> _getStudentData() {
    return {
      'age': int.tryParse(_ageController.text),
      'course': _courseController.text,
      'completionYear': int.tryParse(_completionYearController.text),
      'gender': _selectedGender.toString().split('.').last.toUpperCase(),
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'services': _selectedServices.map((service) => service.toJson()).toList()
    };
  }
  
  void _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      // Show success message and navigate to StudentDashboard
      _showSuccessDialog('Enrollment submitted successfully!');
    } else {
      _showSnackbar('Failed to submit: ${response.statusCode}');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDashboard(details: widget.details),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Student Self-Enrollment'),
      backgroundColor: const Color(0xFF38A3A5),
    ),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: 400,  
                child: FirstNameField(controller: _firstNameController),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,  
                child: LastNameField(controller: _lastNameController),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,  
                child: EmailField(email: widget.email),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,  
                child: AgeField(controller: _ageController),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,  
                child: CourseField(controller: _courseController),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,  
                child: CompletionYearField(controller: _completionYearController),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,  
                child: GenderField(
                  selectedGender: _selectedGender,
                  onChanged: (Gender? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,   
                child: MultiSelectDialogField<PersonalizedService>(
                  items: _availableServices
                      .map((service) => MultiSelectItem(service, service.name))
                      .toList(),
                  title: const Text("Personalized Services"),
                  selectedItemsTextStyle: const TextStyle(color: Colors.blue),
                  onConfirm: (List<PersonalizedService> selected) {
                    setState(() {
                      _selectedServices = selected;
                    });
                  },
                  initialValue: _selectedServices,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}

