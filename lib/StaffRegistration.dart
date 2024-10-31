import 'dart:convert';
//import 'package:chilla_customer/CreateAccount.dart';
import '/staffDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class StaffRegistration extends StatefulWidget {
  final String email;
  final String token;
  final List roles;
  const StaffRegistration(
      {super.key,
      required this.email,
      required this.token,
      required this.roles});

  @override
  State<StaffRegistration> createState() => _StaffRegistrationState();
}

class _StaffRegistrationState extends State<StaffRegistration> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  Future<void> _registerCustomer() async {
    final url = Uri.parse(
        'http://104.237.9.211:8007/karuthal/api/v1/persona/regcustomer');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer ${widget.token}",
    };
    final body = jsonEncode({
      'email': widget.email, // Assuming name is the email
      'job': _jobController.text,
      'city': _cityController.text,
      'country': {
        'id': 1 // Modify based on actual data
      },
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        debugPrint("Registration Successful");
        print(jsonDecode(response.body));

        if (widget.roles.contains('STUDENT')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StaffDashboard(loginOption: 1),
            ),
          );
        } else if (widget.roles.contains('Manager')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StaffDashboard(loginOption: 3),
            ),
          );
        } else {
          print("Not a Student");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF38A3A5),
              content: Text(
                'Not a Student',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }
      } else {
        debugPrint(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Registration failed: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/bluebg.png',
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Staff Registration",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: Color(0xFF38A3A5),
                                    fontFamily:
                                        GoogleFonts.anekGurmukhi().fontFamily,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 27.0,
                                  ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              "Fill out the form carefully for registration",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: const Color(0xFF3A3A3A),
                                    fontFamily:
                                        GoogleFonts.robotoFlex().fontFamily,
                                    fontSize: 16.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildLabelText(context, "Name"),
                      const SizedBox(height: 8),
                      _buildTextField(
                        context,
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      _buildLabelText(context, "Job"),
                      const SizedBox(height: 8),
                      _buildTextField(
                        context,
                        controller: _jobController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Job';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      _buildLabelText(context, "Address"),
                      const SizedBox(height: 8),
                      _buildTextField(
                        context,
                        controller: _addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      _buildLabelText(context, "Permanent Address"),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabelText(context, "Residing Country"),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  context,
                                  controller: _countryController,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabelText(context, "City"),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  context,
                                  controller: _cityController,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      Center(
                        child: SizedBox(
                          height: 48.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF38A3A5),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                print("Email: ${widget.email}");
                                print("Token: ${widget.token}");
                                _registerCustomer(); // Call the API
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Color(0xFF57CC99),
                                    content: Text(
                                      'Please enter the required field',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildLabelText(BuildContext context, String labelText) {
    Color labelColor = (labelText == "Permanent Address")
        ? const Color(0xFF838181)
        : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        labelText,
        style: TextStyle(
          color: labelColor,
          fontSize: 16,
          fontFamily: GoogleFonts.robotoFlex().fontFamily,
        ),
      ),
    );
  }
}
