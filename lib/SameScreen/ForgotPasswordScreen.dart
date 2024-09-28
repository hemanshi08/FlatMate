import 'package:flatmate/SameScreen/OTPVerificationScreen.dart';
import 'package:flutter/material.dart';
import 'loginscreen.dart'; // import your login screen file
import 'OTPVerificationScreen.dart';

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
              //
              // gles
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
                      vertical: screenHeight * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Forgot password',
                        style: TextStyle(
                          fontSize: 43,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD8AFCC),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Enter your email account to reset your password',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Email TextField
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'abc@gmail.com',
                          hintStyle: TextStyle(
                            fontSize: screenHeight * 0.023,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Action Buttons (Cancel and Reset Password)
                      Row(
                        children: [
                          // Cancel Button
                          SizedBox(
                            width: screenWidth * 0.32,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Reset Password Button
                          SizedBox(
                            width: screenWidth * 0.46,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Color(0xFF06001A),
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
