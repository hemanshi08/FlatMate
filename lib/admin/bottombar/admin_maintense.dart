import 'package:flutter/material.dart';
import 'maintense_request_form.dart'; // Ensure this import is present

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Maintenance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26 * textScaleFactor, // Adjusted for text scale factor
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: 60.0,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              // Add your logic for the menu action
            },
          )
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
                    vertical: screenHeight * 0.013,
                    horizontal: screenWidth * 0.06,
                  ), // Button padding
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaintenanceRequestForm(),
                    ),
                  );

                  if (result != null) {
                    // Handle the returned values (title, date, amount)
                    print(
                        result); // You can update the screen with these values
                  }
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
                    true, // Payable status
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
                    false, // Not payable
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
    bool isPayable,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD8AFCC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(
                width: screenWidth * 0.04), // Spacing between icon and text

            // Maintenance Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Responsive font size
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    fee,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // Responsive font size
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // Responsive font size
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
