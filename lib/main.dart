import 'package:firebase_core/firebase_core.dart';
import 'package:flatmate/admin/admin_dashboard.dart';
import 'package:flatmate/data/database_service.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DatabaseService dbService = DatabaseService();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'OpenSans',
      ),
      debugShowCheckedModeBanner: false,
      // Set initial route to SplashScreen
      initialRoute: '/',
      // Define named routes
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/forgotPassword': (context) => ForgotPassword(),
        '/userDashboard': (context) => HomePage(),
         '/adminDashboard': (context) => HomePageA(),
      },
    );
  }
}
