import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../SameScreen/LoginScreen.dart';
import '../../drawer/changepass.dart';
import '../../drawer/contact_details.dart';
import '../../drawer/language.dart';
import '../../drawer/profile.dart';
import '../../drawer/security_details.dart';
import '../admin_dashboard.dart';
import 'expense_form.dart';

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
  const AdminExpense({Key? key}) : super(key: key);

  @override
  _AdminExpenseState createState() => _AdminExpenseState();
}

class _AdminExpenseState extends State<AdminExpense> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? adminId;
  List<ExpenseItem> _expenses = [];
  double _totalExpense = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
    _getTotalExpense();
  }

  Future<void> _deleteExpense(String? expenseId) async {
    if (expenseId != null) {
      await FirebaseDatabase.instance.ref('expenses/$expenseId').remove();
      _fetchExpenses(); // Refresh the expenses list after deletion
    }
  }

  Future<void> _getTotalExpense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalExpense = prefs.getDouble('total_expense') ?? 0;
    });
  }

  Future<void> _saveTotalExpense(double totalExpense) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('total_expense', totalExpense);
  }

  Future<void> _fetchExpenses() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    DataSnapshot expensesSnapshot =
        await databaseReference.child('expenses').get();
    DataSnapshot adminSnapshot = await databaseReference.child('admin').get();

    Map<dynamic, dynamic>? expensesData =
        expensesSnapshot.value as Map<dynamic, dynamic>?;
    Map<dynamic, dynamic>? adminData =
        adminSnapshot.value as Map<dynamic, dynamic>?;

    List<ExpenseItem> expensesList = [];

    if (expensesData != null && adminData != null) {
      expensesData.forEach((key, value) {
        ExpenseItem expense = ExpenseItem.fromMap(value, key); // Use key as id
        expense.ownerName =
            adminData[expense.addedBy]?['ownerName'] ?? 'Unknown';
        expensesList.add(expense);
      });

      setState(() {
        _expenses = expensesList;
        isLoading = false;
      });
    }
  }

  // Future<void> _deleteExpense(String? expenseId) async {
  //   if (expenseId != null) {
  //     await FirebaseDatabase.instance.ref('expenses/$expenseId').remove();
  //     _fetchExpenses();
  //   }
  // }

  Future<void> _navigateToAddExpense() async {
    if (adminId != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddExpenseForm(adminId: adminId!),
        ),
      );
      _fetchExpenses();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin ID not found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Expense List',
          style: TextStyle(fontSize: screenWidth * 0.07, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: screenHeight * 0.08,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            iconSize: screenWidth * 0.095,
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
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
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          const Icon(Icons.add, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'Total Fund: \$$_totalExpense',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
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
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            _expenses[index].title,
                            style: TextStyle(
                              fontSize: screenWidth * 0.043,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: ${_expenses[index].date}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Description: ${_expenses[index].description}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Vendor: ${_expenses[index].vendor}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Amount: \$${_expenses[index].amount}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Added By: ${_expenses[index].ownerName}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () =>
                                    _deleteExpense(_expenses[index].id),
                                child: const Text('Delete'),
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
    );
  }
}
