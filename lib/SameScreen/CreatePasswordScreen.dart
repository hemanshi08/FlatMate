import 'package:flutter/material.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  bool _isnewPasswordVisible = false;
  bool _isconfirmPasswordVisible = false;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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

              // Login form
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 31),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Create Password',
                        style: TextStyle(
                          fontSize: 43,
                          color: Color(0xFFD8AFCC), // Pinkish color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // new password TextField
                      TextField(
                        controller: _newPasswordController,
                        obscureText: !_isnewPasswordVisible,
                        decoration: InputDecoration(
                          //labelText: 'Password',
                          // labelStyle: const TextStyle(color: Colors.white),
                          hintText: 'New Password',
                          hintStyle: TextStyle(
                            fontSize: screenHeight * 0.023,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15), // Decreased height
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isnewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isnewPasswordVisible = !_isnewPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      //Confirm Password TextField
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isconfirmPasswordVisible,
                        decoration: InputDecoration(
                          //labelText: 'Password',
                          // labelStyle: const TextStyle(color: Colors.white),
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(
                            fontSize: screenHeight * 0.023,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15), // Decreased height
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isconfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isconfirmPasswordVisible =
                                    !_isconfirmPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // set Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _set();
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
                            'SET',
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFF06001A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
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

//

  void _set() {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword == confirmPassword) {
      setState(() {
        //print('set password');
      });
    } else {
      setState(() {
        //print('try to set password');
      });
    }
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
