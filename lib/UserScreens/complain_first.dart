import 'package:flatmate/UserScreens/expense_list.dart';
import 'package:flatmate/data/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flatmate/UserScreens/maintanance_screen.dart';
import 'package:flatmate/UserScreens/user_dashboard.dart';
import 'package:flatmate/drawer/contact_details.dart';
import 'package:flatmate/drawer/language.dart';
import 'package:flatmate/drawer/profile.dart';
import 'package:flatmate/drawer/security_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../SameScreen/LoginScreen.dart';
import '../drawer/changepass.dart';

class ComplaintsApp extends StatelessWidget {
  const ComplaintsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ComplaintsScreen(),
    );
  }
}

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  _ComplaintsScreenState createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndexButton = 0;
  int _selectedIndex = 0;
  String? userId; // To store user ID fetched from SharedPreferences
  List<Map<String, dynamic>> solvedComplaints = [];
  List<Map<String, dynamic>> unsolvedComplaints = [];
  bool isLoading = true; // To show loading while data is being fetched

  // Instantiate DatabaseService
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _fetchUserComplaints();
  }

  Future<void> _fetchUserComplaints() async {
    setState(() {
      isLoading = true; // Start loading when fetching begins
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId =
        prefs.getString('user_id'); // Get user_id from SharedPreferences

    if (userId == null) {
      print("User ID not found in SharedPreferences");
      setState(() {
        isLoading = false; // Stop loading if user ID is not found
      });
      return; // Exit the function if userId is null
    }

    try {
      // Fetch all complaints based on user_id
      List<Map<String, dynamic>> complaints =
          await _databaseService.getComplaintsByUserId(userId);

      setState(() {
        // Initialize complaints lists to empty
        solvedComplaints = [];
        unsolvedComplaints = [];

        if (complaints.isNotEmpty) {
          // Separate solved and unsolved complaints
          solvedComplaints = complaints
              .where((complaint) => complaint['status'] == 'Solved')
              .toList();
          unsolvedComplaints = complaints
              .where((complaint) => complaint['status'] == 'Unsolved')
              .toList();
        } else {
          print("No complaints found for user ID: $userId");
        }

        isLoading = false; // Stop loading after fetching data
      });
    } catch (e) {
      print("Error fetching user complaints: $e");
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  // Function to open the complaint form
  void _openComplaintForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintFormScreen(),
      ),
    ).then((_) {
      _fetchUserComplaints(); // Refresh complaints after submitting a new one
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF06001A),
        automaticallyImplyLeading: false,
        title: Text(
          'Complains',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            letterSpacing: 1,
          ),
        ),
        toolbarHeight: 60.0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              iconSize: screenWidth * 0.095,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(screenWidth, screenHeight), // Right-side drawer

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43DBF8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _openComplaintForm,
              icon: Icon(
                Icons.add,
                color: const Color(0xFF06001A),
              ),
              label: Text(
                "Add Complains",
                style: TextStyle(
                  color: const Color(0xFF06001A),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF66123A), width: 2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndexButton = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedIndexButton == 0
                              ? const Color(0xFFD8AFCC)
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Solved Complains",
                            style: TextStyle(
                              fontSize: screenWidth * 0.041,
                              color: selectedIndexButton == 0
                                  ? const Color(0xFF66123A)
                                  : const Color(0xFF66123A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndexButton = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedIndexButton == 1
                              ? const Color(0xFFD8AFCC)
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Unsolved Complains",
                            style: TextStyle(
                              fontSize: screenWidth * 0.041,
                              color: selectedIndexButton == 1
                                  ? const Color(0xFF66123A)
                                  : const Color(0xFF66123A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : selectedIndexButton == 0
                    ? ComplaintsListView(
                        complaints: solvedComplaints,
                        onComplaintSelected: (complaint) {
                          // Convert to Map<String, String>
                          Map<String, String> complaintData = {
                            'title': complaint['title'] ?? '',
                            'date': complaint['date'] ?? '',
                            'description': complaint['description'] ?? '',
                          };
                          _showComplaintDetails(context, complaintData);
                        },
                        isSolved: true, // Pass true for solved complaints
                      )
                    : ComplaintsListView(
                        complaints: unsolvedComplaints,
                        onComplaintSelected: (complaint) {
                          // Convert to Map<String, String>
                          Map<String, String> complaintData = {
                            'title': complaint['title'] ?? '',
                            'date': complaint['date'] ?? '',
                            'description': complaint['description'] ?? '',
                          };
                          _showComplaintDetails(context, complaintData);
                        },
                        isSolved: false, // Pass false for unsolved complaints
                      ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Add logic for navigation on different tabs
          switch (index) {
            case 0:
              // If home is selected, you can refresh the HomePage or stay here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              // Navigate to Maintenance page when Maintenance tab is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MaintenancePage()),
              );
              break;
            case 2:
              break;
            case 3:
              Navigator.push(
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
                      context, LoginScreen()); // Call the logout method
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

// Show Complaint Details Dialog
void _showComplaintDetails(
    BuildContext context, Map<String, String> complaint) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    complaint['title']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                complaint['date']!,
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                complaint['description']!,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ComplaintFormScreen extends StatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  _ComplaintFormScreenState createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _complaintDescriptionController = TextEditingController();
  DateTime? _selectedDate;

  // Instantiate DatabaseService
  final DatabaseService _databaseService = DatabaseService();

  @override
  void dispose() {
    _titleController.dispose();
    _ownerNameController.dispose();
    _complaintDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180,
        backgroundColor: const Color(0xFF06001A),
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 16, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Complain Form",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
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
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: _selectedDate == null
                          ? 'Select Date'
                          : DateFormat('yyyy-MM-dd')
                              .format(_selectedDate!), // Format only the date
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _complaintDescriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Complaint Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your complaint';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? userId = prefs.getString('user_id');

                    if (userId != null) {
                      Map<String, dynamic> complaintData = {
                        'user_id': userId,
                        'title': _titleController.text,
                        'description': _complaintDescriptionController.text,
                        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        'status': 'Unsolved',
                      };

                      await _databaseService.addComplaint(complaintData);

                      Navigator.pop(context);
                    } else {
                      print("User ID not found in SharedPreferences");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8AFCC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: const Color(0xFF66123A),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
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

class ComplaintsListView extends StatelessWidget {
  final List<Map<String, dynamic>> complaints; // Accept the list of complaints
  final Function(Map<String, dynamic>)
      onComplaintSelected; // Callback for selected complaint
  final bool
      isSolved; // Indicates if the list is for solved or unsolved complaints

  const ComplaintsListView({
    Key? key,
    required this.complaints,
    required this.onComplaintSelected,
    required this.isSolved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final complaint = complaints[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(complaint['title']!),
            subtitle: Text(complaint['date']!),
            onTap: () {
              onComplaintSelected(complaint); // This will now work
            },
          ),
        );
      },
    );
  }
}
