import 'package:flatmate/SameScreen/loginscreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds and then navigate to LoginScreen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // big first triangle
          Positioned(
            top: 3,
            left: 0,
            child: CustomPaint(
              size: const Size(0, 250),
              painter: TrianglePainter1(const Color(0xFF31B3CD)),
            ),
          ),

          //small first Triangle
          Positioned(
            top: 10,
            left: 25,
            child: CustomPaint(
              size: const Size(0, 110),
              painter: TrianglePainter2(
                const Color(0xFFD8AFCC),
              ),
            ),
          ),

          //bottom Big Triangle

          Positioned(
            bottom: 140,
            right: 0,
            child: CustomPaint(
              size: const Size(100, 140),
              painter: TrianglePainter3(
                const Color(0xFF31B3CD),
              ),
            ),
          ),

          //bottom Small Triangle

          Positioned(
            bottom: 67,
            right: 22,
            child: CustomPaint(
              size: const Size(45, 60),
              painter: TrianglePainter4(
                const Color(0xFFD8AFCC),
              ),
            ),
          ),

          Center(
            child: Text(
              'FlatMate',
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: screenHeight * 0.09,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      backgroundColor: const Color(0xFF090124), // Dark background color
    );
  }
}

// TrianglePainter class to draw the triangles
//top big triangle
class TrianglePainter1 extends CustomPainter {
  final Color color;
  TrianglePainter1(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();

    path.moveTo(150, 120);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

//Top small Triangle

class TrianglePainter2 extends CustomPainter {
  final Color color;
  TrianglePainter2(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();

    path.moveTo(100, 45);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
//botom Big Triangle

class TrianglePainter3 extends CustomPainter {
  final Color color;
  TrianglePainter3(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();

    path.moveTo(100, 270);
    path.lineTo(size.width, 0);
    path.lineTo(-45, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

//for small bottom triangle

class TrianglePainter4 extends CustomPainter {
  final Color color;
  TrianglePainter4(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();

    path.moveTo(45, 120);
    path.lineTo(size.width, 0);
    path.lineTo(-50, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
