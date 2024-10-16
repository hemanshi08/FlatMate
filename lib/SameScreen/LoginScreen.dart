import 'package:flatmate/UserScreens/user_dashboard.dart';
import 'package:flatmate/data/database_service.dart';
import 'package:flatmate/data/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flatmate/admin/admin_dashboard.dart';
import 'package:flatmate/SameScreen/ForgotPasswordScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF06001A),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 31),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: screenHeight * 0.05,
                          color: const Color(0xFFD8AFCC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.06),

                      // Username TextField
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            fontSize: screenHeight * 0.022,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your username'
                            : null,
                      ),
                      SizedBox(height: screenHeight * 0.032),

                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: screenHeight * 0.022,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your password'
                            : null,
                      ),
                      SizedBox(height: screenHeight * 0.032),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _login();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.010,
                            ),
                            backgroundColor: const Color(0xFF31B3CD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: screenHeight * 0.0245,
                              color: const Color(0xFF06001A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.023),

                      // Forgot password text
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgotPassword()),
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.0235,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.032),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and password cannot be empty')),
      );
      return;
    }

    if (username.startsWith('admin_')) {
      print("Admin login attempted: $username");
      Map<String, dynamic>? adminData =
          await _databaseService.getAdminCredentials(username);

      print("Admin data: $adminData");

      if (adminData != null) {
        String dbPassword = adminData['password'];

        if (dbPassword == password) {
          // Fetch admin ID from the admin data
          String adminID = adminData['admin_id']; // Accessing admin_id directly

          // Save the admin ID to Shared Preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('admin_id', adminID); // Saving the admin ID

          print(
              "Admin ID saved: $adminID"); // Make sure this outputs the correct ID after login

          // Navigate to HomePageA without passing ownerName
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageA(), // No ownerName needed here
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin not found')),
        );
      }
    } else {
      // User login logic
      print("User login attempted: $username");

      // Check the format of the username (e.g., wings_flatno)
      if (!RegExp(r'^[A-Z]_\d{3}$').hasMatch(username)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username format.')),
        );
        return;
      }

      // Retrieve user credentials from residents table
      Map<String, dynamic>? userData =
          await _databaseService.getUserCredentials(username);

      print("User data: $userData");

      if (userData != null) {
        String dbPassword = userData['password'];

        if (dbPassword == password) {
          await SessionManager.saveUserSession(username);

          // Redirect to user dashboard
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    }
  }
}
