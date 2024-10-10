import 'package:flatmate/UserScreens/complain_first.dart';
import 'package:flatmate/UserScreens/maintanance_screen.dart';
import 'package:flatmate/UserScreens/user_dashboard.dart';
import 'package:flatmate/drawer/contact_details.dart';
import 'package:flatmate/drawer/language.dart';
import 'package:flatmate/drawer/profile.dart';
import 'package:flatmate/drawer/security_details.dart';
import 'package:flutter/material.dart';

// Define the ExpenseItem class
class ExpenseItem {
  String title;
  String description;
  int amount;
  String vendor;
  String date;

  ExpenseItem({
    required this.title,
    required this.description,
    required this.amount,
    required this.vendor,
    required this.date,
  });
}

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  List<ExpenseItem> _expenses = [
    ExpenseItem(
      title: 'Cleaning',
      description: 'Monthly Cleaning Service',
      amount: 2000,
      vendor: 'CleanSweep',
      date: '22 Aug, 2024',
    ),
    ExpenseItem(
      title: 'Security',
      description: 'Security system update',
      amount: 20000,
      vendor: 'SecureTech',
      date: '10 Aug, 2024',
    ),
  ];

  int _totalAmount = 50000;

  @override
  void initState() {
    super.initState();
    _calculateTotalAmount();
  }

  void _calculateTotalAmount() {
    _totalAmount = 0;
    for (var expense in _expenses) {
      _totalAmount += expense.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF06001A),
        title: Text(
          'Expense List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            letterSpacing: 1,
          ),
        ),
        toolbarHeight: 60.0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              iconSize: screenWidth * 0.095,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(screenWidth), // Right-side drawer
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 20, horizontal: screenWidth * 0.05),
            margin: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sync,
                  size: screenWidth * 0.12,
                  color: Colors.amber,
                ),
                SizedBox(width: screenWidth * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '₹$_totalAmount',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                return _buildExpenseItem(_expenses[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Add logic for navigation on different tabs
          switch (index) {
            case 0:
              // If home is selected, you can refresh the HomePage or stay here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              // Navigate to Maintenance page when Maintenance tab is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MaintenancePage()),
              ).then((_) {
                setState(() {
                  _selectedIndex = 1; // Ensure the Maintenance tab is selected
                });
              });
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComplaintsScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpenseListScreen()),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  }),
                  _buildDivider(),
                  _buildDrawerItem(Icons.language, 'Language Settings', context,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LanguageSelectionPage()),
                    );
                  }),
                  _buildDivider(),
                  // _buildDrawerItem(Icons.lock, 'Change Password', context, () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => ProfilePage()),
                  //   );
                  // }),
                  // _buildDivider(),
                  _buildDrawerItem(Icons.security, 'Security Details', context,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecurityDetailsPage()),
                    );
                  }),
                  _buildDivider(),
                  _buildDrawerItem(
                      Icons.contact_phone, 'Contact Information', context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactDetailsPage()),
                    );
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

  Widget _buildExpenseItem(ExpenseItem expense) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: const Color(0xFFEDF8F8),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: const Color(0xFFD8AFCC),
              width: screenWidth * 0.02,
            ),
          ),
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expense.date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF43DBF8),
                  ),
                  child: Text(
                    'Download',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: const Color(0xFF06001A),
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.02),
            _buildExpenseDetailRow(
              icon: Icons.title,
              label: 'Title',
              value: expense.title,
              screenWidth: screenWidth,
            ),
            _buildExpenseDetailRow(
              icon: Icons.description,
              label: 'Description',
              value: expense.description,
              screenWidth: screenWidth,
            ),
            _buildExpenseDetailRow(
              icon: Icons.currency_rupee,
              label: 'Amount',
              value: '₹${expense.amount}',
              screenWidth: screenWidth,
            ),
            _buildExpenseDetailRow(
              icon: Icons.person,
              label: 'Vendor',
              value: expense.vendor,
              screenWidth: screenWidth,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the expense detail rows
  Widget _buildExpenseDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required double screenWidth,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: screenWidth * 0.035,
              color: Color.fromARGB(255, 54, 54, 54),
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 54, 54, 54),
                fontSize: screenWidth * 0.035,
                letterSpacing: 0.5,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: Color.fromARGB(221, 28, 27, 27),
                  fontSize: screenWidth * 0.035,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 5), // Add line spacing between rows
      ],
    );
  }
}
