import 'package:flutter/material.dart';
import 'CreatePasswordScreen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String generatedOTP;
  final String username;
  const OTPVerificationScreen({
    Key? key,
    required this.email,
    required this.username,
    required this.generatedOTP,
  }) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String? _errorMessage;

  void _verifyOtp() {
    if (_otpController.text.trim() == widget.generatedOTP) {
      // Proceed to allow the user to reset their password
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CreatePasswordScreen(username: widget.username), // Use username
        ),
      );
    } else {
      setState(() {
        _errorMessage = "Invalid OTP. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification code has been sent to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: "Enter OTP"),
              keyboardType: TextInputType.number, // Limit input to numbers
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text("Verify"),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
