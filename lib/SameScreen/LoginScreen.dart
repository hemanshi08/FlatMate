import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = "";

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
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
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 47,
                          color: Color(0xFFD8AFCC), // Pinkish color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email TextField
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          //labelText: 'Email',
                          //labelStyle: const TextStyle(color: Color(0xFF31B3CD)),
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            fontSize: screenHeight * 0.023,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15), // Decreased height
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Password TextField
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          //labelText: 'Password',
                          // labelStyle: const TextStyle(color: Colors.white),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: screenHeight * 0.023,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15), // Decreased height
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
                      ),
                      const SizedBox(height: 22),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _login();
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
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFF06001A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Forgot password text
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Display message
                      Text(
                        _message,
                        style: TextStyle(
                          color: _message == "Login Successful"
                              ? Colors.green
                              : Colors.red,
                          fontSize: 18,
                        ),
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

  // Login function to compare username and password
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == password) {
      setState(() {
        _message = "Login Successful";
      });
    } else {
      setState(() {
        _message = "Invalid username or password";
      });
    }
  }
}

// TrianglePainter class for creating the background triangles
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
