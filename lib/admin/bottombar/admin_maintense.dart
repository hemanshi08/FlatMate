import 'package:flatmate/admin/admin_dashboard.dart';
import 'package:flatmate/admin/bottombar/admin_complain.dart';
import 'package:flatmate/admin/bottombar/admin_expense.dart';
import 'package:flutter/material.dart';
import 'maintense_request_form.dart'; // Ensure this import is present

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      key: _scaffoldKey,

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
            onPressed: () {
              _scaffoldKey.currentState
                  ?.openEndDrawer(); // Open right-side drawer
            },
          ),
        ],
      ),
      endDrawer: _buildDrawer(screenWidth), // Right-side drawer

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
        currentIndex: 1,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Add logic for navigation on different tabs
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              // Navigate to Maintenance page when Maintenance tab is tapped

              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminComplain()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminExpense()),
              );
              break;
          }
        },
        selectedItemColor: const Color(0xFF31B3CD),
        unselectedItemColor: Color.fromARGB(255, 128, 130, 132),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 16,
        unselectedFontSize: 13,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment, size: 28),
            label: 'Maintenance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback, size: 28),
            label: 'Complaints',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on, size: 28),
            label: 'Expense List',
          ),
        ],
        iconSize: 30,
        elevation: 10,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildDrawer(double screenWidth) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF06001A),
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: screenWidth * 0.25,
                    height: screenWidth * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'HG',
                        style: TextStyle(
                          fontSize: screenWidth * 0.1,
                          color: const Color(0xFF06001A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFE9F2F9),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildDrawerItem(Icons.edit, 'Profile', context, () {
                    // Navigate to Profile Page
                  }),
                  _buildDivider(),
                  _buildDrawerItem(Icons.language, 'Language Settings', context,
                      () {
                    // Navigate to Language Settings Page
                  }),
                  _buildDivider(),
                  _buildDrawerItem(Icons.security, 'Security Details', context,
                      () {
                    // Navigate to Security Details Page
                  }),
                  _buildDivider(),
                  _buildDrawerItem(
                      Icons.contact_phone, 'Contact Information', context, () {
                    // Navigate to Contact Information Page
                  }),
                  _buildDivider(),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Divider(thickness: 2, color: const Color(0xFF06001A)),
              ListTile(
                leading: Icon(Icons.logout, color: const Color(0xFF06001A)),
                title: Text('Logout',
                    style: TextStyle(color: const Color(0xFF06001A))),
                onTap: () {
                  // Handle logout
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context,
      [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF06001A)),
      title: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF06001A),
          fontSize: 16,
        ),
      ),
      onTap: onTap ??
          () {
            // Default tap action (if not provided)
          },
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: const Color(0xFF06001A),
      thickness: 1.5,
      indent: 20,
      endIndent: 20,
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
