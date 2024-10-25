import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart'; // Realtime Database
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import Shared Preferences

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({super.key, required String adminId});

  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _vendorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _selectedFile; // To store selected file
  bool _isUploading = false; // Show progress during file upload
  String? _uploadedFileUrl; // To store uploaded file URL
  String? _adminId; // To store admin ID
  double totalExpense = 0.0; // To store total expense from SharedPreferences

  @override
  void initState() {
    super.initState();
    _fetchAdminId(); // Fetch the admin ID when the widget is initialized
    _fetchTotalExpense(); // Fetch total expense from SharedPreferences
  }

  // Function to fetch admin ID from Shared Preferences
  Future<void> _fetchAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _adminId = prefs.getString('admin_id'); // Fetch the admin ID
      if (_adminId != null) {
        print('Admin ID fetched successfully: $_adminId');
      } else {
        print('Failed to fetch Admin ID.');
      }
    });
  }

  // Function to fetch total expense from SharedPreferences
  Future<void> _fetchTotalExpense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalExpense = prefs.getDouble('total_expense') ?? 0.0;
      // Fetch or set default to 0.0
      print('Total Expense fetched: $totalExpense');
    });
  }

  // Function to update total expense in SharedPreferences
  Future<void> _updateTotalExpense(double newExpense) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    totalExpense +=
        newExpense; // Add or subtract the expense from the current total
    await prefs.setDouble('total_expense',
        totalExpense); // Save the updated total in SharedPreferences
    print('Total Expense updated: $totalExpense');
  }

  // Function to upload the selected file to Firebase Storage
  Future<String?> _uploadFile() async {
    if (_selectedFile == null)
      return null; // If no file is selected, return null

    setState(() {
      _isUploading = true; // Show a loading indicator while uploading
    });

    try {
      String fileName = _selectedFile!.path.split('/').last;
      Reference storageReference =
          FirebaseStorage.instance.ref().child('receipts/$fileName');
      UploadTask uploadTask = storageReference.putFile(_selectedFile!);
      TaskSnapshot snapshot = await uploadTask;
      String fileUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadedFileUrl = fileUrl; // Store the uploaded file URL
        _isUploading = false; // Hide loading indicator
      });

      return fileUrl; // Return file URL to store in Realtime Database
    } catch (e) {
      print('File upload error: $e');
      setState(() {
        _isUploading = false; // Hide loading indicator if there's an error
      });
      return null;
    }
  }

  // Function to submit the form and save data to Firebase Realtime Database
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Print total expense before submitting
      print('Total Expense before submission: $totalExpense');

      // Upload file and get the download URL
      String? receiptUrl = await _uploadFile();

      // Parse the new expense amount from the input
      double newExpenseAmount = double.parse(_amountController.text);

      // Check if the new expense amount is greater than the available total expense
      if (newExpenseAmount > totalExpense) {
        // Show an error if the amount is greater than the available total expense
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The entered amount exceeds the available expense.'),
          backgroundColor: Colors.red,
        ));
        return; // Stop further execution
      }

      // Reference to the expenses node in Firebase
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('expenses');

      // Push a new record to get a unique ID (expense_id)
      DatabaseReference newExpenseRef = databaseRef.push();
      String expenseId =
          newExpenseRef.key ?? ""; // Use the document ID as expense_id

      // Create a new expense object
      final newExpense = {
        "expense_id": expenseId, // Use the document ID as the expense ID
        "title": _titleController.text,
        "date": _dateController.text,
        "amount": newExpenseAmount,
        "vendor": _vendorController.text,
        "description": _descriptionController.text,
        "receipt_url": receiptUrl ?? "", // Save receipt URL or an empty string
        "total_expense":
            totalExpense - newExpenseAmount, // Subtract the expense
        "added_by": _adminId ??
            'Unknown', // Store the admin ID (or 'Unknown' if not set)
      };

      // Save the expense data to Firebase Realtime Database
      await newExpenseRef.set(newExpense);

      // Update the total expense in SharedPreferences by subtracting the new expense
      await _updateTotalExpense(-newExpenseAmount);

      // Show confirmation message or navigate back
      Navigator.pop(
          context, newExpense); // Pass the data back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180, // Keep your toolbar height as you wanted
        backgroundColor: const Color(0xFF06001A),
        automaticallyImplyLeading:
            false, // Disable default back button behavior
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(
              left: 16, top: 50), // Adjust padding as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Add Expense",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Spacer(), // Optional: Adjust spacing between title and other elements if needed
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Expense Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _vendorController,
                  decoration: InputDecoration(labelText: 'Vendor'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the vendor name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: _isUploading
                      ? CircularProgressIndicator()
                      : Text('Submit Expense'),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                    'Current Total Fund: ${totalExpense.toStringAsFixed(2)}'), // Display total expense
              ],
            ),
          ),
        ),
      ),
    );
  }
}
