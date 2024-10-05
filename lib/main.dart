import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flatmate/SameScreen/CreatePasswordScreen.dart';
import 'package:flatmate/SameScreen/ForgotPasswordScreen.dart';
import 'package:flatmate/SameScreen/LoginScreen.dart';
import 'package:flatmate/SameScreen/SplashScreen.dart';
import 'package:flatmate/UserScreens/user_dashboard.dart';

import 'package:flatmate/UserScreens/Announcement.dart';
import 'package:flatmate/UserScreens/complain_first.dart';
import 'package:flatmate/UserScreens/expense_list.dart';
import 'package:flatmate/UserScreens/maintanance_screen.dart';
import 'package:flatmate/UserScreens/residentdetails.dart';
import 'package:flatmate/UserScreens/visitor_log.dart';
import 'package:flatmate/drawer/contact_details.dart';
import 'package:flatmate/drawer/language.dart';

// import 'package:flatmate_apartment/UserScreens/complain_screen.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widget binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //  fontFamily: 'Roboto', for global font family
        fontFamily: 'OpenSans',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
