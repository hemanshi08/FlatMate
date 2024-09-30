import 'package:flutter/material.dart';

import 'expense_form.dart';

class AdminExpense extends StatefulWidget {
  @override
  _AdminExpenseState createState() => _AdminExpenseState();
}

class _AdminExpenseState extends State<AdminExpense> {
  List<Map<String, dynamic>> expenses = [
    {
      "title": "Monthly Electricity Bill",
      "date": "August 15, 2024",
      "description": "Regular monthly electricity bill for the common areas.",
      "vendor": "PowerGrid Inc.",
      "amount": 1200.00,
    },
    {
      "title": "Security Camera Installation",
      "date": "August 20, 2024",
      "description": "Installation of security cameras around the premises.",
      "vendor": "SafeHome Security",
      "amount": 10000.00,
    },
  ];

  // Function to delete an expense
  void _deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  // Function to navigate to AddExpenseForm and receive result
  Future<void> _navigateToAddExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseForm(),
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
      appBar: AppBar(
        title: Text(
          'Expense List',
          style: TextStyle(fontSize: screenWidth * 0.06),
        ),
        backgroundColor: const Color(0xFF06001A),
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
                      color:
                          const Color(0xFF4CD8F4), // Set the background color
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    child: TextButton(
                      onPressed: _navigateToAddExpense,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '  Add Expense',
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontSize:
                                  screenWidth * 0.045, // Responsive font size
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black, // Icon color
                          ),
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
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
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
                            expenses[index]["title"],
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.043, // Slightly smaller font
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
                                'Date : ${expenses[index]["date"]}',
                                style: TextStyle(
                                  fontSize: screenWidth *
                                      0.038, // Slightly smaller font
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Text(
                                'Description : ${expenses[index]["description"]}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Text(
                                'Vendor : ${expenses[index]["vendor"]}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Text(
                                'Amount : ${expenses[index]["amount"].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Implement edit functionality here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255,
                                          122,
                                          197,
                                          143), // Suggest greenish color for EDIT
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.009,
                                        horizontal: screenWidth * 0.06,
                                      ),
                                      elevation: 0, // No shadow
                                    ),
                                    child: Text(
                                      'EDIT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Implement download functionality here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.009,
                                        horizontal: screenWidth * 0.06,
                                      ),
                                      elevation: 0, // No shadow
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.download,
                                          size: screenWidth * 0.04,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Text(
                                          'Download',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _deleteExpense(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.009,
                                        horizontal: screenWidth * 0.06,
                                      ),
                                      elevation: 0, // No shadow
                                    ),
                                    child: Text(
                                      'DELETE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
    );
  }
}
