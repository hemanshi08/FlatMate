import 'package:flatmate/SameScreen/CreatePasswordScreen.dart';
import 'package:flatmate/SameScreen/ForgotPasswordScreen.dart';
import 'package:flatmate/SameScreen/LoginScreen.dart';
import 'package:flatmate/SameScreen/SplashScreen.dart';
import 'package:flatmate/UserScreen/UserDashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            //  fontFamily: 'Roboto', for global font family
            ),
        debugShowCheckedModeBanner: false,
        home: LoginScreen());
  }
}
