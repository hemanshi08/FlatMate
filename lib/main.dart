import 'package:flatmate_apartment/UserScreens/Announcement.dart';
import 'package:flatmate_apartment/UserScreens/complain_first.dart';
import 'package:flatmate_apartment/UserScreens/expense_list.dart';
import 'package:flatmate_apartment/UserScreens/maintanance_screen.dart';
import 'package:flatmate_apartment/UserScreens/residentdetails.dart';
import 'package:flatmate_apartment/UserScreens/visitor_log.dart';
import 'package:flatmate_apartment/drawer/contact_details.dart';
import 'package:flatmate_apartment/drawer/language.dart';
import 'package:flatmate_apartment/drawer/profile.dart';
import 'package:flatmate_apartment/drawer/security_details.dart';

// import 'package:flatmate_apartment/UserScreens/complain_screen.dart';
import 'package:flutter/material.dart';
import 'admin/admin_dashboard.dart';
import 'admin/bottombar/admin_complain.dart';
import 'admin/bottombar/admin_expense.dart';
import 'admin/bottombar/admin_maintense.dart';

void main() {
  runApp(const MyApp());
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
        home:
            MaintenanceScreen() // Adjust this according to your app's homepage
        );
  }
}
