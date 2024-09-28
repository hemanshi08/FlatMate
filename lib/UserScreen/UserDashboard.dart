import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text('FlatMate'),
          ),
          toolbarHeight: 60.0,
          backgroundColor: const Color(0xFF06001A),
          foregroundColor: const Color(0xFFFFFFFF),
          titleTextStyle: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0, top: 4.0),
              child: IconButton(
                  onPressed: () {}, icon: Icon(Icons.menu, size: 35)),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: screenHeight * 0.07),
          color: const Color(0xFF06001A),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'WELCOME',
                style: TextStyle(
                    fontSize: screenWidth * 0.16,
                    color: const Color(0xFF31B3CD),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                'Hemanshi Garnara',
                style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    color: const Color(0xFF31B3CD),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.07),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.all(screenHeight * 0.04),
                child: Text(
                  'This is the User Dashboard',
                ),
              )
            ],
          ),
        ));
  }
}