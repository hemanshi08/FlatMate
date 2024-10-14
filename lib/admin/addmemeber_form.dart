import 'dart:math';
import 'package:flutter/material.dart';
import '../email_service.dart'; // Import the updated email service
import 'package:firebase_database/firebase_database.dart';

class AddMemberForm extends StatefulWidget {
  final Function(Map<String, String>) onMemberAdded;

  const AddMemberForm({super.key, required this.onMemberAdded});

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
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> _submitForm() async {
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

      final email = _emailController.text;
      final flatNo = _flatNoController.text;
      final username = flatNo; // Using flat number as username
      final password = _generateRandomPassword();

      try {
        // Send email to the resident
        await _sendEmailToMember(
          email: email,
          flatNo: flatNo,
          ownerName: _ownerNameController.text,
          people: _peopleController.text,
          contactNo: _contactNoController.text,
          username: username,
          password: password,
        );

        // Add member to Firebase only if email sends successfully
        await _addMemberToDatabase(newMember, password);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Member added and email sent successfully')),
        );
        widget.onMemberAdded(newMember); // Notify parent widget
        Navigator.pop(context); // Close form screen
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      } finally {
        setState(() {
          _isSendingEmail = false; // Reset loading state
        });
      }
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

  Future<void> _addMemberToDatabase(
      Map<String, String> memberData, String password) async {
    final String userId = _generateUserId(); // Generate a unique user ID
    final String username =
        memberData['flatNo']!; // Using flat number as username

    // Push member data to the database, including user_id and username
    await _database.child("residents").push().set({
      ...memberData,
      'password': password, // Store the password in the database
      'user_id': userId, // Store user_id in the database
      'username': username, // Store username in the database
    });
  }

  // Function to generate a unique user ID
  String _generateUserId() {
    // You can customize the user ID generation logic as needed
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
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
                  "Add Resident",
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
        padding: EdgeInsets.all(screenWidth * 0.08),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _flatNoController,
                decoration: InputDecoration(
                  labelText: 'Flat No (e.g., A_101)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter flat number';
                  }
                  if (!RegExp(r'^[A-Z]_\d{3}$').hasMatch(value)) {
                    return 'Flat number must start with a letter, followed by "_" and three digits';
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
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter email' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contactNoController,
                decoration: InputDecoration(
                  labelText: 'Contact No',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter contact number' : null,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _isSendingEmail ? null : _submitForm,
                  child: _isSendingEmail
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text('Add Member'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
