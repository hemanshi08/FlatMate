import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
  String? _selectedOption = 'All Members';
  String? _selectedMember;
  List<Map<String, String?>> _members = []; // List to hold fetched members

  final DatabaseReference _residentsRef =
      FirebaseDatabase.instance.ref().child('residents');

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {
      DatabaseEvent event = await _residentsRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<dynamic, dynamic>? userMap =
            snapshot.value as Map<dynamic, dynamic>?;

        if (userMap != null) {
          setState(() {
            _members = userMap.entries.where((entry) {
              var user = entry.value;
              return user != null &&
                  user['ownerName'] != null &&
                  user['flatNo'] != null &&
                  user['user_id'] != null; // Ensure user_id exists
            }).map((entry) {
              var user = entry.value;
              return {
                'flatNo': user['flatNo']?.toString() ?? 'Unknown Flat',
                'ownerName': user['ownerName']?.toString() ?? 'Unknown Owner',
                'userId': user['user_id']?.toString() ??
                    '', // Use user_id from residents
              };
            }).toList();
          });

          if (_members.isEmpty) {
            print("No residents with valid data found in the database.");
          }
        }
      } else {
        print("No residents found.");
      }
    } catch (error) {
      print("Error fetching residents: $error");
    }
  }

  Future<void> _saveMaintenanceRequest() async {
    final requestId = FirebaseDatabase.instance
        .ref('maintenance_requests')
        .push()
        .key; // Generate a new request ID

    if (requestId != null) {
      // Explicitly declare the type of requestData
      final Map<String, dynamic> requestData = {
        'title': _title,
        'date': _date,
        'amount': double.tryParse(_amount ?? '0'), // Convert amount to double
        'users': <String, bool>{}, // Using bool for the users map
        'payments': <String, Map<String, dynamic>>{}, // New payments field
      };

      // Determine which users to include based on the selected option
      if (_selectedOption == 'All Members') {
        for (var member in _members) {
          final userId = member['userId']; // Safely extract userId

          if (userId != null && userId.isNotEmpty) {
            // Add user to users map safely
            (requestData['users'] as Map<String, bool>)[userId] =
                true; // Add user to users map

            // Initialize payment details for the user
            (requestData['payments']
                as Map<String, Map<String, dynamic>>)[userId] = {
              'payment_id': " ",
              'payment_status': 'Pending', // Default payment status
              'transaction_id': " ",
              'payment_timestamp': " ",
              'receipt_url': " ",
              'payment_method':
                  'Razorpay', // Or any payment method you plan to use
            };
          } else {
            print('User ID is null or empty for member: ${member['flatNo']}');
          }
        }
      } else if (_selectedOption == 'Particular Member' &&
          _selectedMember != null) {
        final selectedUserId = _selectedMember?.split('_')[0]; // Extract userId

        if (selectedUserId != null && selectedUserId.isNotEmpty) {
          // Add user to users map safely
          (requestData['users'] as Map<String, bool>)[selectedUserId] =
              true; // Add user to users map

          // Initialize payment details for the user
          (requestData['payments']
              as Map<String, Map<String, dynamic>>)[selectedUserId] = {
            'payment_status': 'Pending', // Default payment status
            'transaction_id': null,
            'payment_timestamp': null,
            'payment_method':
                'Razorpay', // Or any payment method you plan to use
          };
        } else {
          print('Selected user ID is null or empty');
        }
      }

      // Push the maintenance request data to the database
      await FirebaseDatabase.instance
          .ref('maintenance_requests/$requestId')
          .set(requestData);

      // Optionally show a success message or handle UI updates
      print('Maintenance request saved successfully with ID: $requestId');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveMaintenanceRequest(); // Save the request to the database
      Navigator.pop(context, {
        'title': _title,
        'date': _date,
        'amount': _amount,
        'member': _selectedMember,
      });
    }
  }

  void _showMemberSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _members.length,
          itemBuilder: (context, index) {
            final member = _members[index];
            return ListTile(
              title: Text(
                  'Flat No: ${member['flatNo']}, Owner: ${member['ownerName']}'),
              onTap: () {
                setState(() {
                  _selectedMember =
                      '${member['userId']}_${member['flatNo']}_${member['ownerName']}';
                });
                Navigator.pop(context);
              },
            );
          },
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
                icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              const Spacer(),
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
                  const Text('All Members'),
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
                  const Text('Particular Member'),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
                onSaved: (value) => _title = value,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a date'
                    : null,
                onSaved: (value) => _date = value,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
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
                    minimumSize: const Size(double.infinity, 50),
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
