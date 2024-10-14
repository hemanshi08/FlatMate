import 'package:flutter/material.dart';

class MaintenanceRequestForm extends StatefulWidget {
  @override
  _MaintenanceRequestFormState createState() => _MaintenanceRequestFormState();
}

class _MaintenanceRequestFormState extends State<MaintenanceRequestForm> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _date;
  String? _amount;
  String? _selectedOption = 'All Members';
  String? _selectedMember;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(context, {
        'title': _title,
        'date': _date,
        'amount': _amount,
        'member': _selectedMember
      });
    }
  }

  void _showMemberSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              title: Text('Member 1'),
              onTap: () {
                setState(() {
                  _selectedMember = 'Member 1';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Member 2'),
              onTap: () {
                setState(() {
                  _selectedMember = 'Member 2';
                });
                Navigator.pop(context);
              },
            ),
            // Add more ListTile widgets for additional members
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180,
        backgroundColor: const Color(0xFF06001A),
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05, top: screenHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Text(
                  'Add Maintenance',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.08),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Radio buttons for selecting All Members or Particular Member
              Row(
                children: [
                  Radio<String>(
                    value: 'All Members',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                        _selectedMember =
                            null; // Clear if selecting All Members
                      });
                    },
                  ),
                  Text('All Members'),
                  Radio<String>(
                    value: 'Particular Member',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                        if (value == 'Particular Member') {
                          _showMemberSelectionSheet();
                        }
                      });
                    },
                  ),
                  Text('Particular Member'),
                ],
              ),
              if (_selectedOption == 'Particular Member' &&
                  _selectedMember != null)
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Text(
                    'Selected Member: $_selectedMember',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              SizedBox(height: screenHeight * 0.02),
              // Title TextFormField
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
                onSaved: (value) => _title = value,
              ),
              SizedBox(height: screenHeight * 0.02),
              // Date TextFormField
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a date'
                    : null,
                onSaved: (value) => _date = value,
              ),
              SizedBox(height: screenHeight * 0.02),
              // Amount TextFormField
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter an amount'
                    : null,
                onSaved: (value) => _amount = value,
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8AFCC),
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: const Color(0xFF66123A),
                      fontSize: screenWidth * 0.05,
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
