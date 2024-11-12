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
              numberOfPeople = int.tryParse(adminDetails['people'] ?? '0') ?? 0;
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
              numberOfPeople =
                  int.tryParse(residentDetails['people'] ?? '0') ?? 0;
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
                  // Name field with only bottom line
                  // Name field with label and only bottom line
                  TextFormField(
                    initialValue: editedName,
                    decoration: InputDecoration(
                      labelText: 'Owner Name',
                      labelStyle: TextStyle(color: Colors.indigo),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
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
                  SizedBox(height: 16),

                  // Phone number field with label and only bottom line
                  TextFormField(
                    initialValue: editedPhoneNumber,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.indigo),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
                    onChanged: (value) {
                      editedPhoneNumber = value;
                    },
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

// Number of people field with label and only bottom line
                  TextFormField(
                    initialValue: editedPeople,
                    decoration: InputDecoration(
                      labelText: 'Number of People',
                      labelStyle: TextStyle(color: Colors.indigo),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      editedPeople = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of people';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Save changes button
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          ownerName = editedName;
                          phoneNumber = editedPhoneNumber;
                          numberOfPeople = int.parse(editedPeople);
                        });

                        // Save data to the database
                        await DatabaseService().updateUserProfile(
                            editedName, editedPhoneNumber, editedPeople);

                        // Save to SharedPreferences
                        _saveUserProfileToPreferences();

                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                    ),
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
        toolbarHeight: 80.0,
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
            // Center(
            //   child: ownerName == 'Loading...'
            //       ? CircularProgressIndicator()
            //       : Container(
            //           width: 100.0,
            //           height: 100.0, // Rectangular shape with adjusted height
            //           decoration: BoxDecoration(
            //             borderRadius:
            //                 BorderRadius.circular(30.0), // Rounded corners

            //             //      gradient: LinearGradient(
            //             //   colors: [
            //             //     const Color(0xFF06001A), // Deep Purple
            //             //     const Color(0xFF31B3CD), // Light Teal
            //             //   ],
            //             //   stops: [
            //             //     0.0,
            //             //     1.0
            //             //   ], // Adjusting stops to cover the full range
            //             //   begin: Alignment.bottomLeft,
            //             //   end: Alignment.topRight,
            //             // ),
            //             color: const Color(0xFF06001A), // Deep Purple
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black.withOpacity(0.3),
            //                 spreadRadius: 2,
            //                 blurRadius: 6,
            //                 offset: Offset(0, 4), // Shadow position
            //               ),
            //             ],
            //             border: Border.all(
            //               color: Colors.white, // White border
            //               width: 4.0, // Border width
            //             ),
            //           ),
            //           child: Center(
            //             child: Text(
            //               _getUserInitials(ownerName),
            //               style: TextStyle(
            //                 fontSize: 40, // Large size for visibility
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //         ),
            // ),
            SizedBox(height: 20),
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
            SizedBox(height: 16),
            _buildProfileCard('Name', ownerName),
            _buildProfileCard('Flat Number', flatNumber),
            _buildProfileCard('Email', email),
            _buildProfileCard('Phone', phoneNumber),
            _buildProfileCard('Number of People', numberOfPeople.toString()),
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

  Widget _buildProfileCard(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blueGrey,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Function to get initials based on the ownerName
  // String _getUserInitials(String name) {
  //   if (name.isEmpty) {
  //     return 'NA'; // Return a default value if the name is empty
  //   }

  //   var nameParts = name.split(' ');

  //   // Check if we have at least one part for initials
  //   if (nameParts.length == 1) {
  //     return nameParts[0][0].toUpperCase();
  //   } else if (nameParts.length > 1) {
  //     // Use first letter of first name and surname
  //     return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
  //   } else {
  //     return 'NA'; // Fallback if split doesn't work as expected
  //   }
  // }
}
