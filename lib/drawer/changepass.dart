import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Method to check if a document exists in either 'admin' or 'residents' collection
  Future<bool> _doesDocumentExistInEitherCollection(
      String field, String value) async {
    try {
      // Check in 'admin' collection
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where(field, isEqualTo: value)
          .get();

      // If found in 'admin', return true
      if (adminSnapshot.docs.isNotEmpty) {
        return true;
      }

      // Check in 'residents' collection if not found in 'admin'
      final residentSnapshot = await FirebaseFirestore.instance
          .collection('residents')
          .where(field, isEqualTo: value)
          .get();

      // Return true if found in 'residents'
      return residentSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking document existence: $e');
      return false; // Return false on error
    }
  }

  // Method to validate and submit the form
  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');
      String? id;

      if (username != null) {
        print('Fetched Username: $username');

        if (username.startsWith('admin_')) {
          // User is an admin
          id = prefs.getString('admin_id'); // Fetch admin ID
          if (id != null) {
            print('Fetched Admin ID: $id');

            // Check if the admin document exists
            bool exists =
                await _doesDocumentExistInEitherCollection('admin_id', id);
            if (exists) {
              // Update password in the admin table
              await _updateAdminPassword(id, _newPasswordController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Admin password changed successfully')),
              );
            } else {
              print('Admin document does not exist for ID: $id');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Admin document not found.')),
              );
            }
          } else {
            print('Admin ID is null.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to fetch admin ID')),
            );
          }
        } else {
          // User is a regular resident
          id = prefs.getString('user_id'); // Fetch user ID
          if (id != null) {
            print('Fetched Resident ID: $id');

            // Check if the resident document exists  
            bool exists =
                await _doesDocumentExistInEitherCollection('user_id', id);
            if (exists) {
              // Update password in the resident table
              await _updateResidentPassword(id, _newPasswordController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Resident password changed successfully')),
              );
            } else {
              print('Resident document does not exist for ID: $id');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Resident document not found.')),
              );
            }
          } else {
            print('User ID is null for resident.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to fetch user ID')),
            );
          }
        }
      } else {
        print('No username found in SharedPreferences.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching username')),
        );
      }
    }
  }

  // Update password in admin table
  Future<void> _updateAdminPassword(String id, String newPassword) async {
    try {
      await FirebaseFirestore.instance.collection('admin').doc(id).update({
        'password': newPassword,
      });
      print('Admin password updated successfully.');
    } catch (e) {
      print('Error updating admin password: $e');
      throw e;
    }
  }

  // Update password in resident table
  Future<void> _updateResidentPassword(String id, String newPassword) async {
    try {
      await FirebaseFirestore.instance.collection('residents').doc(id).update({
        'password': newPassword,
      });
      print('Resident password updated successfully.');
    } catch (e) {
      print('Error updating resident password: $e');
      throw e;
    }
  }

  // Helper method to toggle password visibility
  void _togglePasswordVisibility(bool isNewPassword) {
    setState(() {
      if (isNewPassword) {
        _obscureNewPassword = !_obscureNewPassword;
      } else {
        _obscureConfirmPassword = !_obscureConfirmPassword;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Center(
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Old Password field
                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: _obscureOldPassword,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureOldPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureOldPassword = !_obscureOldPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your old password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // New Password field
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            _togglePasswordVisibility(true);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password';
                        } else if (value.length < 6) {
                          return 'Password should be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Confirm Password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            _togglePasswordVisibility(false);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        } else if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    // Change Password Button
                    ElevatedButton(
                      onPressed: _changePassword,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Change Password',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
