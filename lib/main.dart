import 'package:flatmate/SameScreen/CreatePasswordScreen.dart';
import 'package:flatmate/SameScreen/ForgotPasswordScreen.dart';
import 'package:flatmate/SameScreen/LoginScreen.dart';
import 'package:flatmate/SameScreen/SplashScreen.dart';
import 'package:flatmate/UserScreen/UserDashboard.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(
    MaterialApp(
        theme: ThemeData(
            //  fontFamily: 'Roboto', for global font family
            ),
//             builder: (context, widget) => ResponsiveWrapper.builder(
//   BouncingScrollWrapper.builder(context, widget ?? Container()),
//   defaultScale: true,
//   breakpoints: [
//     ResponsiveBreakpoint.resize(350, name: MOBILE),
//     ResponsiveBreakpoint.resize(600, name: TABLET),
//     ResponsiveBreakpoint.resize(800, name: DESKTOP),
//   ],
// ),

        home: SplashScreen()),
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         theme: ThemeData(
//             //  fontFamily: 'Roboto', for global font family
//             ),
//         home: SplashScreen());
//   }
// }
