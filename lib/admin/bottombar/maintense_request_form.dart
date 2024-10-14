import 'package:flutter/material.dart';

class MaintenanceRequestForm extends StatefulWidget {
  const MaintenanceRequestForm({super.key});

  @override
  _MaintenanceRequestFormState createState() => _MaintenanceRequestFormState();
}

class _MaintenanceRequestFormState extends State<MaintenanceRequestForm> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _date;
  String? _amount;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Redirect to the screen where you want to display the values
      Navigator.pop(
          context, {'title': _title, 'date': _date, 'amount': _amount});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180,
        backgroundColor: const Color(0xFF06001A),
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              top: screenHeight * 0.05), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Arrow Icon
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // Title
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              Center(
                child: Text(
                  'Add Maintenance',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08, // Responsive font size
                    letterSpacing: 1,
                  ),
                ),
              ),
              Spacer(), // Optional: Adjust spacing if needed
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.08), // Responsive padding
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title TextFormField
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
              ),
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              // Date TextFormField
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onSaved: (value) => _date = value,
              ),
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              // Amount TextFormField
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
                onSaved: (value) => _amount = value,
              ),
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              SizedBox(
                width: double.infinity, // Full width button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8AFCC),
                    padding: EdgeInsets.symmetric(
                      vertical:
                          screenHeight * 0.01, // Responsive button padding
                    ),
                    minimumSize: Size(double.infinity, 50), // Full-width button
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: const Color(0xFF66123A),
                      fontSize: screenWidth * 0.05, // Responsive font size
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
