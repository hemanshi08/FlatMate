import 'dart:math';
import 'package:flutter/material.dart';
import '../email_service.dart'; // Import the updated email service

class AddMemberForm extends StatefulWidget {
  final Function(Map<String, String>) onMemberAdded;

  const AddMemberForm({Key? key, required this.onMemberAdded})
      : super(key: key);

  @override
  _AddMemberFormState createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _flatNoController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  bool _isSendingEmail = false; // Loading state

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSendingEmail = true; // Set loading state
      });

      final newMember = {
        'flatNo': _flatNoController.text,
        'ownerName': _ownerNameController.text,
        'people': _peopleController.text,
        'email': _emailController.text,
        'contactNo': _contactNoController.text,
      };
      widget.onMemberAdded(newMember);

      final flatNo = _flatNoController.text;
      final username = 'wings_$flatNo';
      final password = _generateRandomPassword();

      _sendEmailToMember(
        email: _emailController.text,
        flatNo: flatNo,
        ownerName: _ownerNameController.text,
        people: _peopleController.text,
        contactNo: _contactNoController.text,
        username: username,
        password: password,
      ).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email sent successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send email: $error')),
        );
      }).whenComplete(() {
        setState(() {
          _isSendingEmail = false; // Reset loading state
        });
        Navigator.pop(context);
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _sendEmailToMember({
    required String email,
    required String flatNo,
    required String ownerName,
    required String people,
    required String contactNo,
    required String username,
    required String password,
  }) async {
    final emailService = EmailService();
    await emailService.sendEmail(
      ownerName: ownerName,
      username: username,
      password: password,
      email: email,
    );
  }

  String _generateRandomPassword() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()'; // Include symbols for better security
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      8, // Length of the generated password
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.24,
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
                  "Add Residents",
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
        // Make the body scrollable
        padding: EdgeInsets.all(screenWidth * 0.08),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _flatNoController,
                decoration: InputDecoration(
                  labelText: 'Flat No (e.g.,A_101)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter flat number';
                  }
                  if (!RegExp(r'^(A_)\d+$').hasMatch(value)) {
                    return 'Flat number must start with "wings no_flat no" followed by digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ownerNameController,
                decoration: InputDecoration(
                  labelText: 'Owner Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter owner name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _peopleController,
                decoration: InputDecoration(
                  labelText: 'No. of People',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter number of people' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email (must be Gmail)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$')
                          .hasMatch(value)) {
                    return 'Enter a valid Gmail address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contactNoController,
                decoration: InputDecoration(
                  labelText: 'Contact No (10 digits)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter contact number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Contact number must be exactly 10 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: _isSendingEmail
                    ? CircularProgressIndicator() // Show loading indicator
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD8AFCC),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: _submitForm,
                        child: Text(
                          'Send Email',
                          style: TextStyle(
                            color: const Color(0xFF66123A),
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
