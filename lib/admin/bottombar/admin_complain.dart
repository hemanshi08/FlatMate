import 'package:flatmate/UserScreens/maintanance_screen.dart';
import 'package:flatmate/admin/admin_dashboard.dart';
import 'package:flatmate/admin/bottombar/admin_expense.dart';
import 'package:flatmate/admin/bottombar/admin_maintense.dart';
import 'package:flutter/material.dart';

class AdminComplain extends StatefulWidget {
  @override
  _AdminComplainState createState() => _AdminComplainState();
}

class _AdminComplainState extends State<AdminComplain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  List<Map<String, String>> complaints = [
    {
      "title": "Water Leakage",
      "date": "07/26/2024",
      "details":
          "There is a water leakage in the basement. Please fix it as soon as possible.",
      "wingFlatNo": "A-101",
      "ownerName": "John Doe",
    },
    {
      "title": "Broken Elevator",
      "date": "08/26/2024",
      "details":
          "The elevator in Building B is not working. Residents are having difficulties.",
      "wingFlatNo": "B-305",
      "ownerName": "Jane Smith",
    },
  ];

  void _solveComplaint(int index) {
    setState(() {
      complaints.removeAt(index); // Remove the complaint from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    double paddingValue = screenWidth * 0.04;

    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        title: Text(
          'Complaints',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: screenHeight * 0.08,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState
                  ?.openEndDrawer(); // Open right-side drawer
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      endDrawer: _buildDrawer(screenWidth), // Right-side drawer

      body: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: screenHeight * 0.02, // Reduced bottom space
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(paddingValue * 0.7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8AFCC),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                complaints[index]["title"]!,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF66123A),
                                  letterSpacing: 0.6,
                                ),
                              ),
                              Text(
                                complaints[index]["date"]!,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF66123A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(paddingValue),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                complaints[index]["details"]!,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.black,
                                  letterSpacing:
                                      0.3, // Increased letter spacing
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                  height:
                                      screenHeight * 0.008), // Reduced space
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _solveComplaint(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 60, 206, 235),
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight *
                                            0.004, // Smaller padding
                                        horizontal: screenWidth * 0.04,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      'SOLVE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenWidth * 0.034,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        complaints[index]["wingFlatNo"]!,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 35, 141, 183),
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      Text(
                                        complaints[index]["ownerName"]!,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color:
                                              Color.fromARGB(255, 35, 141, 183),
                                          letterSpacing: 0.3,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MaintenanceScreen()),
              );
              break;
            case 2:
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
}
