import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String ownerName = 'John Doe';
  String wingNumber = 'A';
  String flatNumber = '101';
  String email = 'johndoe@example.com';
  String phoneNumber = '+1 (123) 456-7890';
  int numberOfPeople = 4;
  String password = 'mysecurepassword'; // Changed to a visible password

  final _formKey = GlobalKey<FormState>();

  // Temporary variables for editing
  String editedName = '';
  String editedPhoneNumber = '';
  String editedPeople = '';
  String editedPassword = '';

  void _editProfile() {
    setState(() {
      editedName = ownerName;
      editedPhoneNumber = phoneNumber;
      editedPeople = numberOfPeople.toString();
      editedPassword = password;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name field
                  TextFormField(
                    initialValue: editedName,
                    decoration: InputDecoration(labelText: 'Owner Name'),
                    onChanged: (value) {
                      editedName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  // Phone number field
                  TextFormField(
                    initialValue: editedPhoneNumber,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    onChanged: (value) {
                      editedPhoneNumber = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  // Number of people field
                  TextFormField(
                    initialValue: editedPeople,
                    decoration: InputDecoration(labelText: 'Number of People'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      editedPeople = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of people';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  // Password field (always visible)
                  TextFormField(
                    initialValue: password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Rounded corners
                        borderSide: BorderSide(
                          color: Colors.grey, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      editedPassword = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          ownerName = editedName;
                          phoneNumber = editedPhoneNumber;
                          numberOfPeople = int.parse(editedPeople);
                          password = editedPassword;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: 60.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16.0 : screenWidth * 0.05,
          vertical: 24.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Owner Information',
                style: TextStyle(
                  fontSize: isSmallScreen ? 22.0 : 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            SizedBox(height: 20),
            ProfileRow(label: 'Name', value: ownerName),
            ProfileRow(label: 'Wing_Flat', value: '$wingNumber,_,$flatNumber'),
            ProfileRow(label: 'Email', value: email),
            ProfileRow(label: 'Phone', value: phoneNumber),
            ProfileRow(
                label: 'Number of People', value: numberOfPeople.toString()),
            ProfileRow(
                label: 'Password',
                value: password), // Displaying password directly
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _editProfile,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
