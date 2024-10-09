import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddAdminScreen extends StatefulWidget {
  final Function(Map<String, String>) onMemberAdded;

  const AddAdminScreen({Key? key, required this.onMemberAdded})
      : super(key: key);

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
  bool _hasPets = false;

  // Reference to the Firebase Realtime Database
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newAdmin = {
        'flatNo': _flatNoController.text,
        'ownerName': _ownerNameController.text,
        'people': _peopleController.text,
        'email': _emailController.text,
        'contactNo': _contactNoController.text,
        'hasPets': _hasPets.toString(),
        'username': 'admin_${_flatNoController.text}', // Generate username
      };

      // Generate a new unique key for the admin
      String adminId = _database.child("admin").push().key!;

      // Save the new admin data to Firebase with admin_id
      _database.child("admin").child(adminId).set({
        ...newAdmin,
        'admin_id': adminId, // Use unique admin_id
      }).then((_) {
        // Notify the parent widget about the new admin addition
        widget.onMemberAdded(newAdmin);
        print("Admin added to Firebase successfully.");
        Navigator.pop(context); // Close the form screen
      }).catchError((error) {
        print("Failed to add admin: $error");
      });
    }
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
                  validator: (value) => value!.isEmpty
                      ? 'Please enter the number of people'
                      : null,
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty ||
                          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
                      ? 'Enter a valid email'
                      : null,
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _contactNoController,
                  decoration: InputDecoration(labelText: 'Contact No'),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty || !RegExp(r'^\d{10}$').hasMatch(value)
                          ? 'Enter a valid 10-digit contact number'
                          : null,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _hasPets,
                      onChanged: (value) => setState(() => _hasPets = value!),
                    ),
                    Text('Send Email'),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8AFCC),
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: const Color(0xFF66123A),
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
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
