import 'dart:math';
import 'package:flatmate/email_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../email_service.dart'; // Import the email service
import 'dart:math';

class AddAdminScreen extends StatefulWidget {
  final Function(Map<String, String>) onMemberAdded;

  const AddAdminScreen({super.key, required this.onMemberAdded});

  @override
  _AddAdminScreenState createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _flatNoController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  bool _isSendingEmail = false; // Loading state

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSendingEmail = true; // Show loading
      });

      final newAdmin = {
        'flatNo': _flatNoController.text,
        'ownerName': _ownerNameController.text,
        'people': _peopleController.text,
        'email': _emailController.text,
        'contactNo': _contactNoController.text,
        'username': 'admin_${_flatNoController.text}', // Generate username
      };

      final email = _emailController.text;
      final flatNo = _flatNoController.text;
      final username = 'admin_$flatNo';
      final password = _generateRandomPassword();

      try {
        await _sendEmailToAdmin(
          email: email,
          username: username,
          password: password,
          ownerName: _ownerNameController.text,
        );

        // Add admin to Firebase only if email sends successfully
        await _addAdminToDatabase(newAdmin, password); // Pass password here

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Admin added and email sent successfully')),
        );
        widget.onMemberAdded(newAdmin); // Notify parent widget
        Navigator.pop(context); // Close form screen
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      } finally {
        setState(() {
          _isSendingEmail = false; // Reset loading
        });
      }
    }
  }

  Future<void> _sendEmailToAdmin({
    required String email,
    required String username,
    required String password,
    required String ownerName,
  }) async {
    final emailService = EmailService();
    await emailService.sendEmail(
      ownerName: ownerName,
      username: username,
      password: password,
      email: email,
    );
  }

  Future<void> _addAdminToDatabase(
      Map<String, String> adminData, String password) async {
    await _database.child("admin").push().set({
      ...adminData,
      'password': password, // Store the password in the database
    });
  }

  String _generateRandomPassword() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()';
    return String.fromCharCodes(Iterable.generate(
      8,
      (_) => characters.codeUnitAt(Random().nextInt(characters.length)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.25,
        backgroundColor: const Color(0xFF06001A),
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.04, top: screenHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Text(
                  "Add Admin",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _flatNoController,
                  decoration: InputDecoration(labelText: 'Flat No'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter flat number' : null,
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _ownerNameController,
                  decoration: InputDecoration(labelText: 'Owner Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter owner name' : null,
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _peopleController,
                  decoration: InputDecoration(labelText: 'No. of People'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty || !RegExp(r'^\d+$').hasMatch(value)
                          ? 'Please enter the number of people in digits'
                          : null,
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter email' : null,
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _contactNoController,
                  decoration: InputDecoration(labelText: 'Contact No'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter contact number' : null,
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: _isSendingEmail
                      ? CircularProgressIndicator() // Show loading indicator
                      : ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Send Email'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
