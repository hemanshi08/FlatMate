import 'package:firebase_database/firebase_database.dart';
import 'package:flatmate/UserScreens/complain_first.dart';
import 'package:flatmate/UserScreens/payment_screen.dart';
import 'package:flatmate/UserScreens/expense_list.dart';
import 'package:flatmate/data/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flatmate/UserScreens/user_dashboard.dart';
import 'package:flatmate/drawer/contact_details.dart';
import 'package:flatmate/drawer/language.dart';
import 'package:flatmate/drawer/profile.dart';
import 'package:flatmate/drawer/security_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  _MaintenancePageState createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final DatabaseReference _maintenanceRequestsRef =
      FirebaseDatabase.instance.ref().child('maintenance_requests');
//final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> _maintenanceRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchMaintenanceRequests();
  }

// Save user_id in SharedPreferences
  Future<void> _saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  // Fetch Maintenance Requests from Firebase
  Future<void> _fetchMaintenanceRequests() async {
    try {
      // Load user_id from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUserId = prefs.getString('user_id');

      if (currentUserId != null) {
        // Fetch data from Firebase
        final DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('maintenance_requests');
        final DataSnapshot snapshot = await ref.get();

        // Check if data exists
        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;

          // Convert the data to a List<Map<String, dynamic>>
          final requests = data.entries.map((entry) {
            final requestKey = entry.key; // Key for the request
            final requestValue = Map<String, dynamic>.from(entry.value
                as Map); // Convert each entry's value to Map<String, dynamic>
            return requestValue;
          }).toList();

          // Log fetched requests before filtering
          print("Fetched requests: $requests");

          // Filter requests by the current user ID
          final filteredRequests = requests.where((request) {
            final users = request['users'] as Map<dynamic, dynamic>? ?? {};
            return users.containsKey(currentUserId);
          }).toList();

          // Log filtered requests
          print("Filtered requests for user $currentUserId: $filteredRequests");

          // Update state with filtered requests
          setState(() {
            _maintenanceRequests = filteredRequests;
          });
        } else {
          print('No maintenance requests found.');
          setState(() {
            _maintenanceRequests = [];
          });
        }
      } else {
        print('No user ID found in SharedPreferences.');
      }
    } catch (e) {
      print('Error fetching maintenance requests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Maintenance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
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
      endDrawer: _buildDrawer(screenWidth), // Right-side drawer
      body: _buildMaintenanceList(screenWidth),

      // body: SingleChildScrollView(
      //   padding: EdgeInsets.all(16),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       _buildMonthSection(
      //           "August, 2024", "₹1000", "5 Aug, 2024", true, screenWidth),
      //       SizedBox(height: 16),
      //       _buildMonthSection(
      //           "July, 2024", "₹1000", "5 July, 2024", false, screenWidth),
      //       SizedBox(height: 16),
      //       _buildMonthSection(
      //           "June, 2024", "₹1000", "5 June, 2024", false, screenWidth),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Add logic for navigation on different tabs
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              // Navigate to Maintenance page when Maintenance tab is tapped
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MaintenancePage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ComplaintsScreen()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
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

  Widget _buildMaintenanceList(double screenWidth) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _maintenanceRequests.isNotEmpty
            ? _maintenanceRequests.map((request) {
                return _buildMonthSection(
                  request['title'] ?? 'No Title',
                  '₹${request['amount'].toString()}',
                  request['date'] ?? 'No Date',
                  request['status'] == 'Pending',
                  screenWidth,
                );
              }).toList()
            : [Text("No maintenance requests found.")],
      ),
    );
  }

  Widget _buildDrawer(double screenWidth) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF06001A),
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: screenWidth * 0.25,
                    height: screenWidth * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'HG',
                        style: TextStyle(
                          fontSize: screenWidth * 0.1,
                          color: const Color(0xFF06001A),
                          fontWeight: FontWeight.bold,
                        ),
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
                  _buildDivider(),
                  _buildDrawerItem(Icons.language, 'Language Settings', context,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LanguageSelectionPage()),
                    );
                  }),
                  _buildDivider(),
                  // _buildDrawerItem(Icons.lock, 'Change Password', context, () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => ProfilePage()),
                  //   );
                  // }),
                  // _buildDivider(),
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
                  // Handle logout
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
    return Divider(
      color: const Color(0xFF06001A),
      thickness: 1.5,
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _buildMonthSection(String month, String amount, String date,
      bool isPayable, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          month,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8AFCC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isPayable ? Icons.insert_drive_file : Icons.check_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Maintenance Fees",
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        amount,
                        style: TextStyle(
                            fontSize: screenWidth * 0.039,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        date,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (isPayable)
                  ElevatedButton(
                    onPressed: () {
                      print(
                          "Pay button clicked"); // Add this line for debugging
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            screenWidth * 0.04, // Button width responsive
                        vertical: 8, // Button height
                      ),
                      backgroundColor: const Color(0xFFD8AFCC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "PAY",
                      style: TextStyle(
                        color: const Color(0xFF66123A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  TextButton(
                    onPressed: () {
                      // Add your download logic here
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            screenWidth * 0.04, // Button width responsive
                        vertical: 8, // Button height
                      ),
                      backgroundColor: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.file_download, color: Colors.blue),
                        SizedBox(width: screenWidth * 0.012),
                        Text(
                          "Download",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
