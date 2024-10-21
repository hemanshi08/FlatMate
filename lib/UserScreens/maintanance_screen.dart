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

  final DatabaseReference _residentsRef = FirebaseDatabase.instance
      .ref()
      .child('residents'); // Reference to residents table
  List<Map<String, dynamic>> _maintenanceRequests = [];

  bool _isLoading = true; // Add loading state

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

  Future<void> _fetchMaintenanceRequests() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUserId = prefs.getString('user_id');

      if (currentUserId != null) {
        final DataSnapshot snapshot = await _maintenanceRequestsRef.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;

          // Convert the data from Firebase to a list of requests
          final requests = data.entries.map((entry) {
            final requestValue = Map<String, dynamic>.from(entry.value as Map);
            requestValue['requestId'] = entry.key; // Add the requestId
            return requestValue;
          }).toList();

          // Filter requests based on the current user ID
          final filteredRequests = requests.where((request) {
            final users = request['users'] as Map<dynamic, dynamic>? ?? {};
            return users.containsKey(
                currentUserId); // Check if user is part of the request
          }).toList();

          // Fetch owner details for each request
          for (var request in filteredRequests) {
            // Fetch owner information from the 'residents' table using the currentUserId
            final residentSnapshot =
                await _residentsRef.child(currentUserId).get();

            if (residentSnapshot.exists) {
              final ownerData =
                  residentSnapshot.value as Map<dynamic, dynamic>? ?? {};

              // Add ownerName and flatNo to each request
              request['ownerName'] = ownerData['ownerName'] ?? 'Unknown Owner';
              request['flatNo'] = ownerData['flatNo'] ?? 'Unknown Flat';
            } else {
              request['ownerName'] = 'Unknown Owner';
              request['flatNo'] = 'Unknown Flat';
            }

            var payments = request['payments'] as Map<dynamic, dynamic>? ?? {};

            // Assume that the current user hasn't paid by default
            request['isPayable'] = true;
            request['canDownloadReceipt'] = false;

            // Check if the current user has made a payment
            if (payments.containsKey(currentUserId)) {
              var userPayment = payments[currentUserId];
              if (userPayment['payment_status'] == 'Paid') {
                request['isPayable'] =
                    false; // User has already paid, so no need to pay again
                request['canDownloadReceipt'] =
                    true; // User can download the receipt
              }
            }
          }

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
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false once data fetch is complete
      });
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _buildMaintenanceList(screenWidth),

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
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _maintenanceRequests.isNotEmpty
            ? _maintenanceRequests.map((request) {
                return _buildMonthSection(
                  request['title'] ?? 'No Title',
                  double.tryParse(request['amount'].toString()) ?? 0.0,
                  request['date'] ?? 'No Date',
                  request['isPayable'], // Pass the isPayable value
                  screenWidth,
                  request['requestId'] ?? '',
                  request['flatNo'] ?? '',
                  request['ownerName'] ?? '',
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

  Widget _buildMonthSection(
    String month,
    double amount,
    String date,
    bool isPayable,
    double screenWidth,
    String requestId,
    String flatNo,
    String ownerName,
  ) {
    // Format the amount for display
    final formattedAmount = '₹${amount.toStringAsFixed(2)}';

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
                        formattedAmount,
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
                      // Print the requestId for debugging
                      print("Pay button clicked for request ID: $requestId");

                      // Navigate to the PaymentScreen with the request details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            requestId: requestId,
                            title: month,
                            amount: amount,
                            flatNo: flatNo,
                            ownerName: ownerName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: 8,
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
                        horizontal: screenWidth * 0.04,
                        vertical: 8,
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
