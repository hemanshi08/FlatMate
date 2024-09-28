import 'package:flatmate/SameScreen/CreatePasswordScreen.dart';
import 'package:flatmate/SameScreen/ForgotPasswordScreen.dart';
import 'package:flatmate/SameScreen/LoginScreen.dart';
import 'package:flatmate/SameScreen/SplashScreen.dart';
import 'package:flatmate/UserScreen/UserDashboard.dart';
import 'package:flatmate/UserScreen/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(
    MaterialApp(
        theme: ThemeData(
          //  fontFamily: 'Roboto', for global font family
          fontFamily: 'OpenSans',
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen()),
  );
}
