import 'dart:math';
import 'package:flatmate/email_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
  bool _isSendingEmail = false;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String newAdminId = '';

  @override
  void initState() {
    super.initState();
    _generateAdminId();
  }

  Future<void> _generateAdminId() async {
    final adminsSnapshot = await _database.child("admin").once();
    final adminsMap = adminsSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (adminsMap != null) {
      int highestId = 1;

      adminsMap.forEach((key, value) {
        String adminId = key;
        if (adminId.startsWith('admin_')) {
          int idNumber = int.parse(adminId.split('_')[1]);
          if (idNumber > highestId) {
            highestId = idNumber;
          }
        }
      });

      newAdminId = 'admin_${(highestId + 1).toString().padLeft(3, '0')}';
    } else {
      newAdminId = 'admin_001';
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSendingEmail = true;
      });

      final email = _emailController.text;
      final flatNo = _flatNoController.text;

      final emailExists = await _checkIfEmailExists(email);
      if (emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Email must be unique. This email already exists.')),
        );
        setState(() {
          _isSendingEmail = false;
        });
        return;
      }

      final username = 'admin_$flatNo';

      final newAdmin = {
        'flatNo': flatNo,
        'ownerName': _ownerNameController.text,
        'people': _peopleController.text,
        'email': email,
        'contactNo': _contactNoController.text,
        'username': username,
      };

      final password = _generateRandomPassword();

      try {
        await _sendEmailToAdmin(
          email: email,
          username: username,
          password: password,
          ownerName: _ownerNameController.text,
        );

        await _addAdminToDatabase(newAdmin, password);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Admin added and email sent successfully')),
        );
        widget.onMemberAdded(newAdmin);
        Navigator.pop(context);
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

  Future<bool> _checkIfEmailExists(String email) async {
    final adminsSnapshot = await _database.child("admin").once();
    final adminsMap = adminsSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (adminsMap != null) {
      for (var value in adminsMap.values) {
        if (value['email'] == email) {
          return true;
        }
      }
    }
    return false;
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
    await _database.child("admin").child(newAdminId).set({
      ...adminData,
      'admin_id': newAdminId,
      'password': password,
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
                      ? CircularProgressIndicator()
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
