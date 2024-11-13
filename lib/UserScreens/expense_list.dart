import 'package:firebase_database/firebase_database.dart';
import 'package:flatmate/UserScreens/complain_first.dart';
import 'package:flatmate/UserScreens/maintanance_screen.dart';
import 'package:flatmate/UserScreens/user_dashboard.dart';
import 'package:flatmate/drawer/contact_details.dart';
import 'package:flatmate/drawer/language.dart';
import 'package:flatmate/drawer/profile.dart';
import 'package:flatmate/drawer/security_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flatmate/data/database_service.dart';
import '../SameScreen/LoginScreen.dart';
import '../data/database_service.dart';
import '../drawer/changepass.dart'; // Ensure this exists and is correctly implemented

class ExpenseItem {
  String title;
  String description;
  int amount;
  String vendor;
  String date;
  String addedBy;
  String ownerName;

  ExpenseItem({
    required this.title,
    required this.description,
    required this.amount,
    required this.vendor,
    required this.date,
    required this.addedBy,
    this.ownerName = 'Unknown',
  });

  factory ExpenseItem.fromMap(Map<dynamic, dynamic> data) {
    return ExpenseItem(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: data['amount'] ?? 0,
      vendor: data['vendor'] ?? '',
      date: data['date'] ?? '',
      addedBy: data['added_by'] ?? 'Unknown',
    );
  }
}

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ExpenseItem> _expenses = [];
  int _selectedIndex = 0;
  double _totalExpense =
      0.0; // Make sure it's a double to match SharedPreferences storage

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
    _getTotalExpense();
  }

  Future<void> _getTotalExpense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Use .toDouble() to ensure the fetched value is treated as double
    setState(() {
      _totalExpense = (prefs.getDouble('total_expense') ?? 0).toDouble();
      print('Total Expense fetched from SharedPreferences: $_totalExpense');
    });
  }

  Future<void> _saveTotalExpense(int totalExpense) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Store totalExpense as a double
    await prefs.setDouble('total_expense', totalExpense.toDouble());
  }

  void _fetchExpenses() async {
    final databaseReference = FirebaseDatabase.instance.ref();

    DataSnapshot expensesSnapshot =
        await databaseReference.child('expenses').get();
    Map<dynamic, dynamic>? expensesData =
        expensesSnapshot.value as Map<dynamic, dynamic>?;

    DataSnapshot adminSnapshot = await databaseReference.child('admin').get();
    Map<dynamic, dynamic>? adminData =
        adminSnapshot.value as Map<dynamic, dynamic>?;

    List<ExpenseItem> expensesList = [];

    if (expensesData != null && adminData != null) {
      for (var value in expensesData.values) {
        ExpenseItem expense = ExpenseItem.fromMap(value);
        String ownerName =
            adminData[expense.addedBy]?['ownerName'] ?? 'Unknown';

        if (ownerName != 'Unknown') {
          print('Owner name for ${expense.addedBy}: $ownerName');
        } else {
          print('Owner not found for ${expense.addedBy}');
        }

        expense.ownerName = ownerName;
        expensesList.add(expense);
      }
    }

    setState(() {
      _expenses = expensesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF06001A),
        title: const Text(
          'Expense List',
          style: TextStyle(color: Colors.white, fontSize: 26, letterSpacing: 1),
        ),
        toolbarHeight: 60.0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              iconSize: screenWidth * 0.095,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(screenWidth, screenHeight),
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
                    spreadRadius: 2),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sync, size: screenWidth * 0.12, color: Colors.amber),
                SizedBox(width: screenWidth * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Fund',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '₹$_totalExpense', // Display total expense
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              // Navigate to Maintenance page when Maintenance tab is tapped
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MaintenancePage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ComplaintsScreen()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
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

  Widget _buildExpenseItem(ExpenseItem expense) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
        title: Text(expense.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${expense.description}'),
            Text('Vendor: ${expense.vendor}'),
            Text('Date: ${expense.date}'),
            Text('Added By: ${expense.ownerName}'),
          ],
        ),
        trailing: Text('₹${expense.amount}'),
      ),
    );
  }

  Widget _buildDrawer(double screenWidth, double screenHeight) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF06001A),
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Container(
                    width: screenWidth * 0.25,
                    height: screenWidth * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/flatmate_logo.png', // Replace with the path to your logo image
                        width: screenWidth *
                            0.4, // Adjust width as needed based on screen width
                        height: screenWidth * 0.2, // Adjust height as needed
                        fit: BoxFit
                            .contain, // Adjust how the image fits within the size
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
                  // _buildDivider(),
                  // _buildDrawerItem(Icons.language, 'Language Settings', context,
                  //     () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => LanguageSelectionPage()),
                  //   );
                  // }),
                  _buildDivider(),
                  _buildDrawerItem(Icons.lock, 'Change Password', context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordPage()),
                    );
                  }),
                  _buildDivider(),
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
                  _databaseService.logout(
                      context, LoginScreen()); // 5Call the logout method
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(color: Colors.black),
    );
  }
}
