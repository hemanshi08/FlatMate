import 'package:flutter/material.dart';

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
  bool _hasPets = false; // Checkbox for pets

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newMember = {
        'flatNo': _flatNoController.text,
        'ownerName': _ownerNameController.text,
        'people': _peopleController.text,
        'email': _emailController.text,
        'contactNo': _contactNoController.text,
        'hasPets': _hasPets.toString(), // Convert bool to string for storage
      };
      widget.onMemberAdded(newMember);
      Navigator.pop(context); // Go back after adding member
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180, // Keep your toolbar height as you wanted
        backgroundColor: const Color(0xFF06001A),
        automaticallyImplyLeading:
            false, // Disable default back button behavior
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(
              left: 16, top: 50), // Adjust padding as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Arrow Icon
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // Title
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Add Member",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Spacer(), // Optional: Adjust the spacing between the title and other elements if needed
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _flatNoController,
                  decoration: InputDecoration(labelText: 'Flat No'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter flat number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ownerNameController,
                  decoration: InputDecoration(labelText: 'Owner Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter owner name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _peopleController,
                  decoration: InputDecoration(labelText: 'No. of People'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of people';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contactNoController,
                  decoration: InputDecoration(labelText: 'Contact No'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Enter a valid 10-digit contact number';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _hasPets,
                      onChanged: (value) {
                        setState(() {
                          _hasPets = value!;
                        });
                      },
                    ),
                    Text('Send Email'),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8AFCC),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    minimumSize: Size(double.infinity, 50), // Full-width button
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: const Color(0xFF66123A),
                      fontSize: 17,
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
