import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'LoginScreen.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String username;

  const CreatePasswordScreen({Key? key, required this.username})
      : super(key: key);

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
              Positioned(
                top: 40,
                right: 0,
                child: CustomPaint(
                  size: Size(screenWidth * 0.22, screenHeight * 0.03),
                  painter: TrianglePainter2(const Color(0xFFD8AFCC)),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: CustomPaint(
                  size: Size(screenWidth * 0.165, screenHeight * 0.14),
                  painter: TrianglePainter2(const Color(0xFFD8AFCC)),
                ),
              ),
              Positioned(
                top: 42,
                right: 0,
                child: CustomPaint(
                  size: Size(screenWidth * 0.25, screenHeight * 0.10),
                  painter: TrianglePainter1(const Color(0xFF31B3CD)),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: CustomPaint(
                  size: Size(screenWidth * 0, screenHeight * 0.155),
                  painter: TrianglePainter1(const Color(0xFF31B3CD)),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 31),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: screenWidth * 0.090,
                          color: const Color(0xFFD8AFCC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.06),
                      TextField(
                        controller: _newPasswordController,
                        obscureText: !_isNewPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'New Password',
                          hintStyle: TextStyle(fontSize: screenHeight * 0.022),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.012,
                            horizontal: screenWidth * 0.04,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.032),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(fontSize: screenHeight * 0.022),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.012,
                            horizontal: screenWidth * 0.04,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.032),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _set,
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
                            'SET',
                            style: TextStyle(
                              fontSize: screenHeight * 0.0245,
                              color: const Color(0xFF06001A),
                              fontWeight: FontWeight.bold,
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

  void _set() async {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Print the username
    print('Username: ${widget.username}');

    // Validation for empty fields
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    // Check if the new password matches the confirm password
    if (newPassword == confirmPassword) {
      try {
        DatabaseReference adminRef =
            FirebaseDatabase.instance.ref().child('admin');

        DataSnapshot adminSnapshot = await adminRef
            .orderByChild('username')
            .equalTo(widget.username)
            .get();

        if (adminSnapshot.exists) {
          // Update password in the 'admin' table
          String adminKey = adminSnapshot.children.first.key!;
          await adminRef.child(adminKey).update({'password': newPassword});
        } else {
          // Check if the user exists in the 'residents' table by username
          DatabaseReference residentRef =
              FirebaseDatabase.instance.ref().child('residents');

          DataSnapshot residentSnapshot = await residentRef
              .orderByChild('username')
              .equalTo(widget.username)
              .get();

          if (residentSnapshot.exists) {
            // Update password in the 'residents' table
            String residentKey = residentSnapshot.children.first.key!;
            await residentRef
                .child(residentKey)
                .update({'password': newPassword});
          } else {
            _showErrorDialog('User not found in database.');
            return;
          }
        }

        // Navigate to the dashboard after successful update
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (e) {
        print('Error updating password: $e');
        // Show error message if the update fails
        _showErrorDialog('Failed to update password. Please try again.');
      }
    } else {
      // Show error if passwords do not match
      _showErrorDialog('The new password and confirmation do not match.');
    }
  }

  // Helper function to show error dialogs
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class TrianglePainter1 extends CustomPainter {
  final Color color;
  TrianglePainter1(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();
    path.moveTo(120, 180);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TrianglePainter2 extends CustomPainter {
  final Color color;
  TrianglePainter2(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();
    path.moveTo(100, 150);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
