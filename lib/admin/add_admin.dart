import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
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
  bool _hasPets = false;

  // Reference to the Firebase Realtime Database
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Function to generate a default password for the admin
  String _generateDefaultPassword(String ownerName) {
    Random random = Random();
    int randomNumber = random.nextInt(999); // Generate a random number (0-999)
    String password = '${ownerName.toLowerCase()}_$randomNumber';
    return password;
  }

  // Function to submit the form
  void _submitForm() async {
    print("Validating form...");

    if (_formKey.currentState!.validate()) {
      print("Form is valid, proceeding with submission...");

      try {
        // Check if the flat number or owner name is already in use
        DatabaseEvent existingAdminByFlatNo = await _database
            .child("admin")
            .orderByChild("flatNo")
            .equalTo(_flatNoController.text)
            .once();

        DatabaseEvent existingAdminByOwnerName = await _database
            .child("admin")
            .orderByChild("ownerName")
            .equalTo(_ownerNameController.text)
            .once();

        if (existingAdminByFlatNo.snapshot.exists ||
            existingAdminByOwnerName.snapshot.exists) {
          print('Flat number or Owner name already exists');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Flat number or Owner name is already in use')),
          );
          return;
        }

        // Generate a username based on the flat number and owner name
        final username = 'admin_${_flatNoController.text}';

        // Generate a default password based on the owner name
        final defaultPassword =
            _generateDefaultPassword(_ownerNameController.text);

        final newAdmin = {
          'flatNo': _flatNoController.text,
          'ownerName': _ownerNameController.text,
          'people': _peopleController.text,
          'email': _emailController.text,
          'contactNo': _contactNoController.text,
          'hasPets': _hasPets.toString(),
          'username': username, // Generate username based on flatNo
          'password': defaultPassword, // Generate default password
        };

        // Generate a new unique key for the admin
        String adminId = _database.child("admin").push().key!;

        // Save the new admin data to Firebase with admin_id
        await _database.child("admin").child(adminId).set({
          ...newAdmin,
          'admin_id': adminId, // Use unique admin_id
        });

        // Log success
        print("Admin added to Firebase successfully.");

        // Notify the parent widget about the new admin addition
        widget.onMemberAdded(newAdmin);
        Navigator.pop(context); // Close the form screen
      } catch (error) {
        print("Failed to add admin: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add admin: $error')),
        );
      }
    } else {
      // Log invalid form
      print("Form validation failed.");
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
                    Text('Has Pets'),
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
