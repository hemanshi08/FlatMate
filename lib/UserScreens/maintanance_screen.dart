import 'package:flatmate/UserScreens/payment_screen.dart';
import 'package:flutter/material.dart';

class MaintenancePage extends StatefulWidget {
  @override
  _MaintenancePageState createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Maintenance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSection(
                "August, 2024", "₹1000", "5 Aug, 2024", true, screenWidth),
            SizedBox(height: 16),
            _buildMonthSection(
                "July, 2024", "₹1000", "5 July, 2024", false, screenWidth),
            SizedBox(height: 16),
            _buildMonthSection(
                "June, 2024", "₹1000", "5 June, 2024", false, screenWidth),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple[800],
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), label: 'Maintenance'),
          BottomNavigationBarItem(
              icon: Icon(Icons.report_problem), label: 'Complain Box'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Expense List'),
        ],
      ),
    );
  }

  Widget _buildMonthSection(String month, String amount, String date,
      bool isPayable, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          month,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(16),
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
                    isPayable ? Icons.insert_drive_file : Icons.check_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Maintenance Fees",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        amount,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        date,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (isPayable)
                  ElevatedButton(
                    onPressed: () {
                      print(
                          "Pay button clicked"); // Add this line for debugging
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            screenWidth * 0.04, // Button width responsive
                        vertical: 8, // Button height
                      ),
                      backgroundColor: const Color(0xFFD8AFCC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "PAY",
                      style: TextStyle(
                        color: const Color(0xFF66123A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  TextButton(
                    onPressed: () {
                      // Add your download logic here
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            screenWidth * 0.04, // Button width responsive
                        vertical: 8, // Button height
                      ),
                      backgroundColor: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.file_download, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          "Download",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
