import 'package:flatmate/SameScreen/LoginScreen.dart';
import 'package:flatmate/UserScreens/user_dashboard.dart';
import 'package:flatmate/admin/bottombar/admin_complain.dart';
import 'package:flatmate/admin/bottombar/admin_expense.dart';
import 'package:flatmate/admin/bottombar/admin_maintense.dart';
import 'package:flatmate/data/database_service.dart';
import 'package:flatmate/drawer/contact_details.dart';
import 'package:flatmate/drawer/language.dart';
import 'package:flatmate/drawer/profile.dart';
import 'package:flatmate/drawer/security_details.dart';
import 'package:flutter/material.dart';
import '../drawer/changepass.dart';
import 'add_admin.dart';
import 'admin_announcement.dart';
import 'admin_rules.dart';
import 'admin_visitor.dart';
import 'maintense_history.dart';
import 'resident_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flatmate/data/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageA extends StatefulWidget {
  const HomePageA({super.key});

  @override
  _HomePageAState createState() => _HomePageAState();
}

class _HomePageAState extends State<HomePageA> {
  final DatabaseService _databaseService =
      DatabaseService(); // Create an instance of DatabaseService

  int _selectedIndex = 0;

  String? ownerName; // To store the fetched owner name
  String? adminId; // To store the admin ID

  @override
  void initState() {
    super.initState();
    _loadOwnerDetails(); // Load the owner details when the widget initializes
  }

  // Fetch the admin ID and owner's name from shared preferences
  Future<void> _loadOwnerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminId = prefs.getString('admin_id');

    if (adminId != null) {
      String? fetchedOwnerName =
          await _databaseService.getOwnerNameByAdminId(adminId!);

      setState(() {
        ownerName = fetchedOwnerName ?? 'Owner';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF06001A),
        elevation: 0,
        title: Text(
          ' FlatMate',
          style: TextStyle(
            color: Colors.white,
            fontSize:
                screenWidth * 0.090, // Font size is 9% of the screen width
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              iconSize: screenWidth * 0.095,
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Opens the endDrawer
              },
            ),
          ),
        ],
        // automaticallyImplyLeading: false, // Disable the back arrow
      ),
      endDrawer:
          _buildDrawer(screenWidth, screenHeight), // Updated drawer design
      body: Container(
        color: const Color(0xFF06001A), // Dark background
        child: Column(
          children: [
            SizedBox(
                height:
                    screenHeight * 0.11), // Adjusted spacing for even padding
            Text(
              'WELCOME',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:
                    screenWidth * 0.10, // Font size is 10% of the screen width
                color: const Color(0xFF31B3CD),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              (ownerName ?? '')
                  .toUpperCase(), // Dynamically display the owner name
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.072,
                color: const Color(0xFF31B3CD),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
                height: screenHeight * 0.05), // Even padding between elements
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: EdgeInsets.all(50),
                child: GridView.count(
                  padding: EdgeInsets.only(
                    top: 30,
                    bottom: 30,
                  ),
                  crossAxisCount: 2,
                  crossAxisSpacing: 21,
                  mainAxisSpacing: 34,
                  children: [
                    // Inside the _buildGridItem function for Rules & Regulation
                    _buildGridItem(
                      Icons.article,
                      'Rules & Regulation',
                      context,
                      AdminRulesScreen(), // Provide a default value if ownerName is null
                    ),

                    _buildGridItem(Icons.notifications_active, 'Announcement',
                        context, AnnouncementScreen()),
                    _buildGridItem(
                        Icons.people, 'Residents', context, ResidentsPage()),
                    _buildGridItem(
                        Icons.badge, 'Visitor', context, VisitorRecordScreen()),
                    _buildGridItem(Icons.history, 'Maintenance History',
                        context, MaintenanceHistoryScreen()), // New button
                    _buildGridItem(
                      Icons.person_add,
                      'Add Admin',
                      context,
                      AddMemberForm(onMemberAdded: (memberData) {
                        // Handle the new member data here
                      }),
                    ),
// New button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) async {
          setState(() {
            _selectedIndex = index;
          });

          // Add logic for navigation on different tabs
          switch (index) {
            case 0:
              // If home is selected, you can refresh the HomePage or stay here
              var refresh = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePageA()),
              );
              if (refresh == true) {
                setState(() {
                  // Trigger a refresh on HomePageA if needed
                });
              }
              break;
            case 1:
              // Navigate to Maintenance page when Maintenance tab is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MaintenanceScreen()),
              ).then((_) {
                setState(() {
                  _selectedIndex = 1; // Ensure the Maintenance tab is selected
                });
              });
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminComplain()),
              );
              break;
            case 3:
              Navigator.push(
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

  Widget _buildGridItem(
      IconData icon, String label, BuildContext context, Widget targetScreen) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 117, // Set a fixed width for the boxes
            height: 117, // Set a fixed height for the boxes
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 240, 238, 238),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Icon(icon, size: 45, color: Colors.black87),
            ),
          ),
          SizedBox(height: 7), // Space between box and title
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: const Color.fromARGB(221, 43, 42, 42), // Changed color
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Updated Drawer Design with Profile Header and Menu Items
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
