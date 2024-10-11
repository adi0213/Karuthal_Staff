import 'dart:convert';
import '/StaffRegistration.dart';
import '/Login.dart';
import '/design.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'UserWaitingPage.dart';
import 'global_api_constants.dart';

class CreateAccount extends StatefulWidget {
  static String bearerToken = "";
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _PhoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedRole = 'Student'; // Default selected role

  Future<void> _signUp() async {
  if (!_formKey.currentState!.validate()) return;

  String apiUrl = getSignupUrl();

  final Map<String, dynamic> requestData = {
    'mobile': _PhoneNumberController.text.trim(),
    'email': _emailController.text.trim(),
    'persona': _selectedRole!.toLowerCase(), // Sending selected role in lowercase
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(requestData),
    );

    // Decode the response body
    final responseData = json.decode(response.body);

    // Print the response data for debugging purposes
    print('Response data: $responseData');

    // Check if the 'status' field exists in the response
    if (responseData['status'] == 200) {
      print('Status 200: Account created successfully.');
      // Show success dialog and navigate to UserWaitingPage
      //_showSuccessDialog('Account created successfully!', UserWaitingPage());
    } else if (responseData['status'] == 406) {
      print('Status 406: Username or email already taken.');

      // Handle the specific error for username/email already taken
      String errorMessage = responseData['message'] ?? 'An error occurred.';
      print('Error message: $errorMessage');

      // Show error dialog with the specific message
      _showErrorDialog(errorMessage);
    } else {
      print('Other status code: ${responseData['status']}');
      // Handle other status codes
      _showErrorDialog('Failed to create account. Please try again.');
    }
  } catch (e) {
    // Handle any exceptions or errors
    print('Error occurred: $e');
    _showErrorDialog('Error occurred. Please try again later.');
  }
}

void _showSuccessDialog(String message, Widget page) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Success'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => page),
            ); // Navigate to the new page
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            'Create Account',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: Color(0xFF38A3A5),
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40.0,
                                ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildLabelText(context, "Email"),
                        const SizedBox(height: 2),
                        _buildProjectedTextFormField(
                          controller: _emailController,
                          isPassword: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildLabelText(context, "Phone Number"),
                        const SizedBox(height: 2),
                        _buildProjectedTextFormField(
                          controller: _PhoneNumberController,
                          isPassword: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length != 10) {
                              return 'Must be 10 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildLabelText(context, "Role Requested"),
                        const SizedBox(height: 2),
                        _buildRoleDropdown(), // Dropdown for role selection
                        const SizedBox(height: 40),
                        Center(
                          child: SizedBox(
                            height: 48.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF38A3A5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _signUp,
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Dropdown for selecting role
  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          value: _selectedRole,
          onChanged: (String? newValue) {
            setState(() {
              _selectedRole = newValue;
            });
          },
          items: ['Student', 'Manager']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(value),
              ),
            );
          }).toList(),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelText(BuildContext context, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        labelText,
        style: TextStyle(
          color: Color(0xFF838181),
          fontSize: 16,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
      ),
    );
  }

  Widget _buildProjectedTextFormField({
    required TextEditingController controller,
    required bool isPassword,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: Color(0xFF838181),
          obscureText: isPassword,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          ),
          validator: validator,
        ),
      ),
    );
  }
}
