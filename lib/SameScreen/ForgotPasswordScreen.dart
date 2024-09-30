import 'package:flatmate/SameScreen/OTPVerificationScreen.dart';
import 'package:flutter/material.dart';
import 'loginscreen.dart'; // Import your login screen file

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF06001A), // Dark background color
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight, // Full screen height
          width: screenWidth, // Full screen width
          child: Stack(
            children: [
              // Triangles
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

              // Forgot Password Form
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.09,
                    vertical: screenHeight * 0.04,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: screenWidth * 0.090, // Adjust font size
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD8AFCC),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.034), // Dynamic height
                      Text(
                        'Enter your email account to reset your password',
                        style: TextStyle(
                          fontSize: screenHeight * 0.022, // Adjust font size
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.06), // Dynamic height

                      // Email TextField
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'abc@gmail.com',
                          hintStyle: TextStyle(
                            fontSize: screenHeight * 0.022, // Adjust font size
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.012, // Dynamic padding
                            horizontal: screenWidth * 0.05,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.032), // Dynamic height

                      // Action Buttons (Cancel and Reset Password)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Cancel Button
                          SizedBox(
                            width: screenWidth * 0.31,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the LoginScreen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF13E16),
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      screenHeight * 0.011, // Dynamic padding
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.046,
                                  // Adjust font size
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // Reset Password Button
                          SizedBox(
                            width: screenWidth * 0.483,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the OTPVerificationScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OTPVerificationScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF31B3CD),
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      screenHeight * 0.011, // Dynamic padding
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.046,
                                  //  fontWeight:
                                  //    FontWeight.bold, // Adjust font size
                                  color: const Color(0xFF06001A),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
}

// TrianglePainter1 and TrianglePainter2 remain the same
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
