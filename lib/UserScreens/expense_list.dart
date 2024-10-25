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

import '../data/database_service.dart'; // Ensure this exists and is correctly implemented

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ExpenseItem> _expenses = [];
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
      endDrawer: _buildDrawer(screenWidth),
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
      bottomNavigationBar: _buildBottomNavigationBar(),
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 3,
      onTap: (index) {
        // Handle navigation
      },
      selectedItemColor: const Color(0xFF31B3CD),
      unselectedItemColor: const Color.fromARGB(255, 128, 130, 132),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 16,
      unselectedFontSize: 13,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.payment, size: 28), label: 'Maintenance'),
        BottomNavigationBarItem(
            icon: Icon(Icons.feedback, size: 28), label: 'Complaints'),
        BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on, size: 28), label: 'Expense List'),
      ],
      iconSize: 30,
      elevation: 10,
      showUnselectedLabels: true,
    );
  }

  Widget _buildDrawer(double screenWidth) {
    // Drawer implementation
    return Drawer(
        // Drawer code
        );
  }
}
