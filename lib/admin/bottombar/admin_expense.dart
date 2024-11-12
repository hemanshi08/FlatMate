import 'package:flatmate/UserScreens/maintanance_screen.dart';
import 'package:flatmate/admin/admin_dashboard.dart';
import 'package:flatmate/admin/bottombar/admin_complain.dart';
import 'package:flatmate/admin/bottombar/admin_maintense.dart';
import 'package:flatmate/drawer/contact_details.dart';
import 'package:flatmate/drawer/language.dart';
import 'package:flatmate/drawer/profile.dart';
import 'package:flatmate/drawer/security_details.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Realtime Database
import 'package:shared_preferences/shared_preferences.dart';
import '../../SameScreen/LoginScreen.dart';
import '../../drawer/changepass.dart';
import 'expense_form.dart';
import 'package:flatmate/data/database_service.dart';

class ExpenseItem {
  String title;
  String description;
  int amount;
  String vendor;
  String date;
  String addedBy;
  String ownerName;
  String id; // Unique ID for deletion

  ExpenseItem({
    required this.title,
    required this.description,
    required this.amount,
    required this.vendor,
    required this.date,
    required this.addedBy,
    this.ownerName = 'Unknown',
    required this.id,
  });

  factory ExpenseItem.fromMap(Map<dynamic, dynamic> data, String id) {
    return ExpenseItem(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: data['amount'] ?? 0,
      vendor: data['vendor'] ?? '',
      date: data['date'] ?? '',
      addedBy: data['added_by'] ?? 'Unknown',
      id: id,
    );
  }
}

class AdminExpense extends StatefulWidget {
  const AdminExpense({super.key});

  @override
  _AdminExpenseState createState() => _AdminExpenseState();
}

class _AdminExpenseState extends State<AdminExpense> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ExpenseItem> expenses = []; // Changed to ExpenseItem
  String? adminId;
  double _totalExpense = 0.0;
  late DatabaseReference databaseReference; // Declare the reference
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    databaseReference =
        FirebaseDatabase.instance.ref(); // Initialize databaseReference
    _fetchExpenses();
    _getAdminId();
  }

  Future<void> _getAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminId = prefs.getString('admin_id'); // Fetching admin ID
  }

  Future<void> _fetchExpenses() async {
    try {
      DataSnapshot expensesSnapshot =
          await databaseReference.child('expenses').get();
      DataSnapshot adminSnapshot = await databaseReference.child('admin').get();

      // Ensure the data is a Map
      Map<dynamic, dynamic>? expensesData = expensesSnapshot.value
          as Map<dynamic, dynamic>?; // Fetch expenses data
      Map<dynamic, dynamic>? adminData =
          adminSnapshot.value as Map<dynamic, dynamic>?; // Fetch admin data

      List<ExpenseItem> expensesList = [];

      // Check if expensesData is not null
      if (expensesData != null) {
        // Loop through each entry in expensesData
        expensesData.forEach((key, value) {
          // Check if the value is a Map<String, dynamic>
          if (value is Map<dynamic, dynamic>) {
            // Create an ExpenseItem from the Map
            ExpenseItem expense =
                ExpenseItem.fromMap(value, key); // Use key as id

            // Fetch the owner name from the admin data based on the addedBy field
            if (adminData != null) {
              var adminInfo = adminData[expense.addedBy];
              if (adminInfo != null && adminInfo is Map) {
                expense.ownerName =
                    adminInfo['ownerName'] ?? 'Unknown'; // Set ownerName
              }
            }

            expensesList.add(expense);
          }
        });

        setState(() {
          expenses = expensesList; // Update the expenses list
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching expenses: $e')),
      );
    }
  }

  // Function to delete an expense
  void _deleteExpense(int index) async {
    try {
      String expenseId = expenses[index].id; // Get the ID of the expense
      await databaseReference
          .child('expenses/$expenseId')
          .remove(); // Delete from Realtime Database

      setState(() {
        expenses.removeAt(index);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting expense: $e')),
      );
    }
  }

  Future<void> _navigateToAddExpense() async {
    if (adminId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin ID is not available.')),
      );
      return; // Exit the function if adminId is null
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddExpenseForm(adminId: adminId!), // Pass adminId here
      ),
    );

    // If result is not null, add the new expense to the list
    if (result != null) {
      setState(() {
        expenses.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Expense List',
          style: TextStyle(
              fontSize: screenWidth * 0.07,
              color: Colors.white,
              letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: screenHeight * 0.08,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            iconSize: screenWidth * 0.095,
            onPressed: () {
              _scaffoldKey.currentState
                  ?.openEndDrawer(); // Open right-side drawer
            },
          ),
        ],
      ),
      endDrawer: _buildDrawer(screenWidth, screenHeight),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CD8F4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: _navigateToAddExpense,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '  Add Expense',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.045),
                          ),
                          Icon(Icons.add, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8AFCC),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            expenses[index].title,
                            style: TextStyle(
                                fontSize: screenWidth * 0.043,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date : ${expenses[index].date}',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.038,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Text(
                                'Description : ${expenses[index].description}',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.038,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Text(
                                'Vendor : ${expenses[index].vendor}',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.038,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              // Text(
                              //   'Added By : ${expenses[index].addedBy}',
                              //   style: TextStyle(
                              //       fontSize: screenWidth * 0.038,
                              //       fontWeight: FontWeight.w500),
                              // ),
                              // SizedBox(height: screenHeight * 0.008),
                              Text(
                                'Owner Name : ${expenses[index].ownerName}',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.038,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Text(
                                'Amount : ₹${expenses[index].amount}',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.038,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () => _deleteExpense(
                                        index), // Delete on click
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
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
                MaterialPageRoute(builder: (context) => HomePageA()),
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
                // onTap: () {
                //   _databaseService.logout(
                //       context, LoginScreen()); // Call the logout method
                // },
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
