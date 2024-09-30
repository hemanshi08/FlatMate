import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rules',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: 60.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading with blue color and underline
              Text(
                'Must follow below rules',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.red, // Heading color set to blue
                  // decoration: TextDecoration.underline,
                  decorationColor:
                      Colors.red, // Underline matches the heading color
                  decorationThickness: 2,
                ),
              ),
              SizedBox(height: 10),
              RuleCard(
                text:
                    'Residents are responsible for maintaining the cleanliness and condition of their unit.',
                screenWidth: screenWidth,
              ),
              RuleCard(
                text:
                    'In case of emergencies (e.g., major leaks, electrical issues), contact 1234567890 immediately.',
                screenWidth: screenWidth,
              ),
              RuleCard(
                text:
                    'Please respect quiet hours from 11PM to 6AM. Excessive noise or disturbances are not permitted.',
                screenWidth: screenWidth,
              ),
              RuleCard(
                text:
                    'Lock all doors and windows when leaving your unit. Report any security concerns to 9874563210.',
                screenWidth: screenWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RuleCard extends StatelessWidget {
  final String text;
  final double screenWidth;

  const RuleCard({
    required this.text,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: Color.fromARGB(
              255, 245, 247, 248), // New background color for the card
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: TextStyle(
              color: const Color.fromARGB(255, 63, 62, 62),
              fontSize: 17), // Text style remains consistent
        ),
      ),
    );
  }
}

// void main() => runApp(MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//       home: RulesPage(),
//     ));
