import 'package:flatmate/UserScreens/user_dashboard.dart';
import 'package:flatmate/data/database_service.dart';
import 'package:flatmate/data/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flatmate/admin/admin_dashboard.dart';
import 'package:flatmate/SameScreen/ForgotPasswordScreen.dart';
import 'package:flatmate/data/OwnerProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService =
      DatabaseService(); // Create an instance of DatabaseService

  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final DatabaseService _databaseService =
  //     DatabaseService(); // Initialize the service

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF06001A), // Dark background color
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight, // Full screen height
          width: screenWidth, // Full screen width
          child: Stack(
            children: [
              // Triangles and other decorations...
              // Login form
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
                          fontSize: screenHeight * 0.05, // Responsive font size
                          color: const Color(0xFFD8AFCC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: screenHeight * 0.06), // Responsive spacing

                      // Username TextField
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            fontSize:
                                screenHeight * 0.022, // Responsive font size
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
                      SizedBox(
                          height: screenHeight * 0.032), // Responsive spacing

                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize:
                                screenHeight * 0.022, // Responsive font size
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
                      SizedBox(
                          height: screenHeight * 0.032), // Responsive spacing

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _login();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  screenHeight * 0.010, // Responsive padding
                            ),
                            backgroundColor: const Color(0xFF31B3CD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize:
                                  screenHeight * 0.0245, // Responsive font size
                              color: const Color(0xFF06001A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: screenHeight * 0.023), // Responsive spacing

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
                              fontSize:
                                  screenHeight * 0.0235, // Responsive font size
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: screenHeight * 0.032), // Responsive spacing
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

      print("Admin data: $adminData"); // Debugging

      if (adminData != null) {
        String dbPassword = adminData['password'];

        if (dbPassword == password) {
          // Fetch ownerName directly from the adminData
          String ownerName = adminData['ownerName'] ??
              'Unknown Owner'; // Fetch ownerName from adminData
          print('Navigating to admin dashboard: $ownerName'); // Debugging

          // Save session using SessionManager
          await SessionManager.saveAdminSession(username);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageA(ownerName: ownerName),
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
      // User login logic...
    }
  }
}
