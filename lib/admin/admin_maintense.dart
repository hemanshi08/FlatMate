import 'package:flutter/material.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06001A),
        title: Text(
          'Maintenance',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.05, // Responsive font size
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Icon(Icons.menu),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Make Request" Button
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015,
                    horizontal: screenWidth * 0.06,
                  ), // Button padding
                ),
                onPressed: () {
                  // Handle button press
                },
                child: Text(
                  'Make Request',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Maintenance History List
            Expanded(
              child: ListView(
                children: [
                  // July, 2024 Section
                  Text(
                    "July, 2024",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  maintenanceCard(
                    screenWidth,
                    screenHeight,
                    textScaleFactor,
                    'Maintenance Fees',
                    '₹1000',
                    '5 July, 2024',
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // June, 2024 Section
                  Text(
                    "June, 2024",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  maintenanceCard(
                    screenWidth,
                    screenHeight,
                    textScaleFactor,
                    'Maintenance Fees',
                    '₹1000',
                    '5 June, 2024',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), label: 'Maintenance'),
          BottomNavigationBarItem(
              icon: Icon(Icons.announcement), label: 'Announcement'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Expense List'),
        ],
        currentIndex: 1, // Set the active tab
        selectedItemColor: const Color(0xFF66123A),
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Maintenance card widget
  Widget maintenanceCard(
    double screenWidth,
    double screenHeight,
    double textScaleFactor,
    String title,
    String fee,
    String date,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.04,
      ), // Responsive padding for the card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(screenWidth * 0.02), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2), // Shadow offset
          ),
        ],
      ),
      child: Row(
        children: [
          // Circle with check icon
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.pink[800],
              size: screenWidth * 0.07, // Responsive icon size
            ),
          ),
          SizedBox(width: screenWidth * 0.04), // Spacing between icon and text

          // Maintenance Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.045, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                fee,
                style: TextStyle(
                  fontSize: screenWidth * 0.04, // Responsive font size
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                date,
                style: TextStyle(
                  fontSize: screenWidth * 0.04, // Responsive font size
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
