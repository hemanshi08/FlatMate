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

  Future<String> _generateNewAdminId() async {
    final adminRef = _database.child("admin");
    final snapshot = await adminRef.get();

    int maxId = 1;
    if (snapshot.exists) {
      // Iterate through existing admin IDs to find the highest ID
      snapshot.children.forEach((admin) {
        final adminId = admin.child('admin_id').value.toString();
        final idNum = int.tryParse(adminId.replaceAll("admin_", "")) ?? 1;
        if (idNum > maxId) {
          maxId = idNum;
        }
      });
    }
    // Increment the highest ID to generate the next admin ID
    final newAdminId = 'admin_${(maxId + 1).toString().padLeft(3, '0')}';
    return newAdminId;
  }

  Future<void> _submitForm({bool isAdmin = false}) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSendingEmail = true;
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
      final username = isAdmin ? await _generateNewAdminId() : 'admin_$flatNo';
      final password = _generateRandomPassword();

      try {
        // Check if the email or username already exists
        bool emailExists = await _checkIfEmailExists(email);
        bool usernameExists = await _checkIfUsernameExists(username);

        if (emailExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: Email ID already exists')),
          );
        } else if (usernameExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: Flat No is already exist')),
          );
        } else {
          await _sendEmailToMember(
            email: email,
            flatNo: flatNo,
            ownerName: _ownerNameController.text,
            people: _peopleController.text,
            contactNo: _contactNoController.text,
            username: username,
            password: password,
          );

          await _addMemberToDatabase(newMember, password, username);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Admin added and email sent successfully')),
          );
          widget.onMemberAdded(newMember);
          Navigator.pop(context);
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      } finally {
        setState(() {
          _isSendingEmail = false;
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
      Map<String, String> memberData, String password, String username) async {
    final newMemberRef = _database.child("admin").push();
    final userId = newMemberRef.key;

    await newMemberRef.set({
      'admin_id': userId,
      'username': username,
      ...memberData,
      'password': password,
    });
  }

  Future<bool> _checkIfEmailExists(String email) async {
    final snapshot = await _database
        .child('admin')
        .orderByChild('email')
        .equalTo(email)
        .once();

    return snapshot.snapshot.exists;
  }

  Future<bool> _checkIfUsernameExists(String username) async {
    final snapshot = await _database
        .child('admin')
        .orderByChild('username')
        .equalTo(username)
        .once();

    return snapshot.snapshot.exists;
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
                  onPressed: _isSendingEmail
                      ? null
                      : () => _submitForm(
                          isAdmin: false), // Set to true if adding admin
                  child: _isSendingEmail
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text('Add Admin'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
