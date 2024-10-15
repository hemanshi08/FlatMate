import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'OTPVerificationScreen.dart';
import 'LoginScreen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _usernameController = TextEditingController();
  String? _generatedOTP; // Initialize the OTP as nullable
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  Future<String?> _fetchEmailFromUsername(String username) async {
    String? email;
    DatabaseReference userRef =
        dbRef.child(username.startsWith('admin_') ? 'admin' : 'residents');

    try {
      final snapshot = await userRef
          .orderByChild('username')
          .equalTo(username)
          .limitToFirst(1)
          .get();

      if (snapshot.exists && snapshot.value != null) {
        final data = Map<dynamic, dynamic>.from(snapshot.value as Map);
        if (data.isNotEmpty) {
          email = data.values.first['email'] as String?;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User not found or data is empty.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No user found with this username.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching email: $e")),
      );
    }
    return email;
  }

  Future<void> sendOTPEmail(String email) async {
    // Ensure _generatedOTP is not null before sending the email
    if (_generatedOTP == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: OTP is not generated.")),
      );
      return;
    }

    final smtpServer = gmail('flatmate110@gmail.com',
        'zcsy kqfc klge kzye'); // Use App Password here
    final message = Message()
      ..from = Address('flatmate110@gmail.com', 'FlatMate')
      ..recipients.add(email)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP for resetting your password is $_generatedOTP.';

    try {
      await send(message, smtpServer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP sent to your email!")),
      );
      // Inside the sendOTPEmail method in ForgotPassword class
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            email: email, // Ensure this variable exists and is correct
            generatedOTP:
                _generatedOTP!, // Ensure this variable exists and is correct
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Could not send OTP.")),
      );
    }
  }

  void resetPassword() async {
    String username = _usernameController.text.trim();

    if (username.isNotEmpty) {
      String? email = await _fetchEmailFromUsername(username);
      if (email != null) {
        _generatedOTP =
            (Random().nextInt(9000) + 1000).toString(); // Generate OTP
        await sendOTPEmail(email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username not found.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid username.")),
      );
    }
  }

  void cancel() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const LoginScreen(), // Navigate to your LoginScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06001A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD8AFCC),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Enter your username to reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetPassword,
                child: Text('Reset Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: cancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Customize the color
                ),
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
