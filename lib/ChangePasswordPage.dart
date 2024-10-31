import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  final String token;

  ChangePasswordPage({required this.token});

  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> changePassword() async {
    // Call API to change password
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: 'Enter OTP'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: changePassword,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
