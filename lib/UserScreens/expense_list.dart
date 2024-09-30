import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpenseListScreen(),
    );
  }
}

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
      appBar: AppBar(
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
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Add your logic for the menu action
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: screenWidth * 0.05,
            ),
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
                  size: screenWidth * 0.12, // Responsive icon size
                  color: Colors.amber,
                ),
                SizedBox(width: screenWidth * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Responsive text size
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '₹$_totalAmount',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1, // Responsive amount size
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
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle navigation
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Maintenance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Complain Box',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Expense List',
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(ExpenseItem expense) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: const Color(0xFFF8F8F8),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: const Color(0xFFD8AFCC),
              width: screenWidth * 0.02, // Responsive border width
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
                    fontSize: screenWidth * 0.04, // Responsive date size
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF43DBF8),
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
              size: screenWidth * 0.035, // Smaller icon size
              color: Color.fromARGB(255, 54, 54, 54),
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 54, 54, 54),
                fontSize: screenWidth * 0.035, // Smaller font size
                letterSpacing: 0.5,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: Color.fromARGB(221, 28, 27, 27),
                  fontSize: screenWidth * 0.035, // Smaller font size
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
