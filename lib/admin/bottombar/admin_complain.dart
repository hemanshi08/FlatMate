import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flatmate/UserScreens/maintanance_screen.dart';
import 'package:flatmate/admin/admin_dashboard.dart';
import 'package:flatmate/admin/bottombar/admin_expense.dart';
import 'package:flatmate/admin/bottombar/admin_maintense.dart';
import 'package:flutter/material.dart';
import 'package:flatmate/drawer/contact_details.dart';
import 'package:flatmate/drawer/language.dart';
import 'package:flatmate/drawer/profile.dart';
import 'package:flatmate/drawer/security_details.dart';

import '../../SameScreen/LoginScreen.dart';
import '../../data/database_service.dart';
import '../../drawer/changepass.dart';

class AdminComplain extends StatefulWidget {
  const AdminComplain({super.key});

  @override
  _AdminComplainState createState() => _AdminComplainState();
}

class _AdminComplainState extends State<AdminComplain> {
  final DatabaseService _databaseService = DatabaseService();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  // Fetch complaints from Firebase Realtime Database
  Stream<DatabaseEvent> getComplaintsStream() {
    return FirebaseDatabase.instance
        .ref()
        .child('complaints')
        .orderByChild('status')
        .equalTo('Unsolved')
        .onValue;
  }

  // Function to mark complaint as solved (not deleting from the database)
  void _solveComplaint(String complaintId) async {
    await FirebaseDatabase.instance
        .ref()
        .child('complaints')
        .child(complaintId)
        .update({'status': 'Solved'});
  }

  // Fetch resident details (flatNo, ownerName) by userId from residents table
  Future<Map<String, dynamic>> fetchResidentDetails(String userId) async {
    DatabaseReference residentRef =
        FirebaseDatabase.instance.ref().child('residents').child(userId);
    DataSnapshot snapshot = await residentRef.get();

    if (snapshot.exists && snapshot.value != null) {
      // Cast the value to a Map<String, dynamic>
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      return {
        'flatNo': data['flatNo'] ?? 'No Flat Number',
        'ownerName': data['ownerName'] ?? 'No Owner Name',
      };
    } else {
      return {'flatNo': 'No Flat Number', 'ownerName': 'No Owner Name'};
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    double paddingValue = screenWidth * 0.04;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Complaints',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: screenHeight * 0.08,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            iconSize: screenWidth * 0.095,
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      endDrawer: _buildDrawer(screenWidth, screenHeight), // Right-side drawer
      body: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: StreamBuilder<DatabaseEvent>(
          stream: getComplaintsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(child: Text("No complaints found."));
            }

            // Parse the complaints from the snapshot (Realtime Database returns a Map)
            Map<dynamic, dynamic> complaintsMap =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List complaints = complaintsMap.entries.toList();

            return ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final complaint = complaints[index].value;
                final complaintId = complaints[index].key;
                final userId = complaint['user_id'] ?? 'No User ID';

                // Fetch resident details based on userId
                return FutureBuilder<Map<String, dynamic>>(
                  future: fetchResidentDetails(userId),
                  builder: (context, residentSnapshot) {
                    if (residentSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (residentSnapshot.hasError) {
                      return Text('Error fetching resident details');
                    }

                    // If the resident details were fetched successfully
                    final residentDetails = residentSnapshot.data!;
                    final flatNo =
                        residentDetails['flatNo'] ?? 'No Flat Number';
                    final ownerName =
                        residentDetails['ownerName'] ?? 'No Owner Name';

                    return Container(
                      margin: EdgeInsets.only(
                        bottom: screenHeight * 0.02, // Reduced bottom space
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Complaint Title and Date
                          Container(
                            padding: EdgeInsets.all(paddingValue * 0.7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8AFCC),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  complaint['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF66123A),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                Text(
                                  complaint['date'] ?? 'No Date',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF66123A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(paddingValue),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Complaint Description
                                Text(
                                  complaint['description'] ?? 'No Description',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.black,
                                    letterSpacing:
                                        0.3, // Increased letter spacing
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                    height:
                                        screenHeight * 0.008), // Reduced space
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _solveComplaint(complaintId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 60, 206, 235),
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight *
                                              0.004, // Smaller padding
                                          horizontal: screenWidth * 0.04,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Text(
                                        'SOLVE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.8,
                                          fontWeight: FontWeight.w800,
                                          fontSize: screenWidth * 0.034,
                                        ),
                                      ),
                                    ),
                                    // Flat No and Owner Name (from resident details)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Flat No: $flatNo",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 35, 141, 183),
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        Text(
                                          "Owner: $ownerName",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            color: Color.fromARGB(
                                                255, 35, 141, 183),
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
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
                );
              },
            );
          },
        ),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePageA()),
              );
              break;
            case 1:
              // Navigate to Maintenance page when Maintenance tab is tapped
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MaintenanceScreen()),
              );
              break;
            case 2:
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminExpense()),
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
