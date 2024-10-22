import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/database_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String ownerName = 'Loading...';
  String wingNumber = 'Loading...';
  String flatNumber = 'Loading...';
  String email = 'Loading...';
  String phoneNumber = 'Loading...';
  int numberOfPeople = 0;

  final _formKey = GlobalKey<FormState>();
  String editedName = '';
  String editedPhoneNumber = '';
  String editedPeople = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username'); // Fetch the stored username
    String? userId;

    if (username != null) {
      print('Fetched username: $username');

      // Determine role based on username
      if (username.startsWith('admin_')) {
        // User is an admin
        userId = prefs.getString('admin_id'); // Fetch admin ID
        if (userId != null) {
          final adminDetails =
              await DatabaseService().fetchAdminDetails(userId);
          if (adminDetails != null) {
            print('Admin details fetched: $adminDetails');
            setState(() {
              ownerName = adminDetails['ownerName'] ?? 'N/A';
              flatNumber = adminDetails['flatNo'] ?? 'N/A';
              email = adminDetails['email'] ?? 'N/A';
              phoneNumber = adminDetails['contactNo'] ?? 'N/A';
              numberOfPeople = adminDetails['numberOfPeople'] ?? 0;
            });
            return; // Exit if admin details are found
          } else {
            print('Admin document does not exist.');
          }
        } else {
          print('Admin ID is null.');
        }
      } else {
        // User is a regular resident
        userId = prefs.getString('user_id'); // Fetch user ID
        if (userId != null) {
          final residentDetails =
              await DatabaseService().fetchResidentDetails(userId);
          if (residentDetails != null) {
            print('Resident details fetched: $residentDetails');
            setState(() {
              ownerName = residentDetails['ownerName'] ?? 'N/A';
              flatNumber = residentDetails['flatNo'] ?? 'N/A';
              email = residentDetails['email'] ?? 'N/A';
              phoneNumber = residentDetails['contactNo'] ?? 'N/A';
              numberOfPeople = residentDetails['numberOfPeople'] ?? 0;
            });
            return; // Exit if resident details are found
          } else {
            print('Resident document does not exist.');
          }
        } else {
          print('User ID is null for resident.');
        }
      }

      // If no details found for either admin or resident
      print('No details found for user ID: $userId');
      setState(() {
        ownerName = 'N/A';
        flatNumber = 'N/A';
        email = 'N/A';
        phoneNumber = 'N/A';
        numberOfPeople = 0;
      });
    } else {
      print('No username found in SharedPreferences.');
    }
  }

  Future<void> _saveUserProfileToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('ownerName', ownerName);
    await prefs.setString('wingNumber', wingNumber);
    await prefs.setString('flatNumber', flatNumber);
    await prefs.setString('email', email);
    await prefs.setString('phoneNumber', phoneNumber);
    await prefs.setInt('numberOfPeople', numberOfPeople);
  }

  void _editProfile() {
    setState(() {
      editedName = ownerName;
      editedPhoneNumber = phoneNumber;
      editedPeople = numberOfPeople.toString();
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          ownerName = editedName;
                          phoneNumber = editedPhoneNumber;
                          numberOfPeople = int.parse(editedPeople);
                        });
                        _saveUserProfileToPreferences();
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
            ProfileRow(label: 'Wing_Flat', value: '$flatNumber'),
            ProfileRow(label: 'Email', value: email),
            ProfileRow(label: 'Phone', value: phoneNumber),
            ProfileRow(
                label: 'Number of People', value: numberOfPeople.toString()),
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
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
