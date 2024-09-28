import 'package:flutter/material.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0018), // Dark background color
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight, // Full screen height
          width: screenWidth, // Full screen width
          child: Stack(children: [
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
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // OTP Verification Title
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCCAACF), // Light pink color
                      ),
                    ),
                    const SizedBox(height: 40),

                    // OTP Code Label
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'OTP Code',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFFCCAACF), // White color for label
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: screenWidth *
                              0.16, // Adjust width as per screen size
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Colors.white, // Background color of the box
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 17,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            // To automatically jump to the next field
                            onChanged: (value) {
                              if (value.length == 1 && index < 3) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 22),

                    // Verify Button
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle OTP Verification action
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 11, horizontal: 10),
                          backgroundColor:
                              const Color(0xFF31B3CD), // Cyan button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF06001A), // Button text color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: OTPVerificationScreen()));
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
