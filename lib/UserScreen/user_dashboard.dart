import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06001A),
        elevation: 0,
        title: Text(
          'FlatMate',
          style: TextStyle(
            color: Colors.white,
            fontSize:
                screenWidth * 0.090, // Font size is 9% of the screen width
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
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
              'Hemanshi Garnara',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:
                    screenWidth * 0.08, // Font size is 8% of the screen width
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
                    _buildGridItem(Icons.article, 'Rules & Regulation', context,
                        RulesScreen()),
                    _buildGridItem(
                        Icons.notifications_active,
                        'Announcement',
                        context,
                        AnnouncementScreen()), // Updated Icon for Announcement
                    _buildGridItem(
                        Icons.people, 'Residents', context, ResidentsScreen()),
                    _buildGridItem(Icons.badge, 'Visitor', context,
                        VisitorScreen()), // Updated Icon for Visitor
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF31B3CD),
        unselectedItemColor: Color.fromARGB(255, 128, 130, 132),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 16, // Increased font size for labels
        unselectedFontSize: 13, // Default font size for unselected labels
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28), // Increased icon size
            label: 'Home', // Added colon to the label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment, size: 28), // Updated Icon
            label: 'Maintenance', // Updated Label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback, size: 28), // Increased icon size
            label: 'Complaints', // Added colon to the label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on, size: 28), // Updated Icon
            label: 'Expense List', // Updated Label
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
          // Drawer Header with Profile Initials
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF06001A), // Dark background color
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: screenWidth * 0.25,
                    height: screenWidth * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(10), // Rounded profile box
                    ),
                    child: Center(
                      child: Text(
                        'HG', // Initials
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
          // Drawer Items
          Expanded(
            child: Container(
              color: const Color(
                  0xFFE9F2F9), // Light blue background for the rest of the drawer
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildDrawerItem(Icons.edit, 'Edit Profile'),
                  _buildDivider(),
                  _buildDrawerItem(Icons.language, 'Language Settings'),
                  _buildDivider(),
                  _buildDrawerItem(Icons.lock, 'Change Password'),
                  _buildDivider(),
                  _buildDrawerItem(Icons.security, 'Security Details'),
                  _buildDivider(),
                  _buildDrawerItem(Icons.contact_phone, 'Contact Information'),
                  _buildDivider(),
                ],
              ),
            ),
          ),
          // Logout Button
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

  // Helper to build Drawer Items
  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF06001A)),
      title: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF06001A),
          fontSize: 16,
        ),
      ),
      onTap: () {
        // Handle each tap
      },
    );
  }

  // Divider for drawer items
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(color: Colors.black),
    );
  }
}

// Dummy screens for navigation
class RulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rules & Regulation')),
      body: Center(child: Text('Rules & Regulation Screen')),
    );
  }
}

class AnnouncementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Announcement')),
      body: Center(child: Text('Announcement Screen')),
    );
  }
}

class ResidentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Residents')),
      body: Center(child: Text('Residents Screen')),
    );
  }
}

class VisitorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Visitor')),
      body: Center(child: Text('Visitor Screen')),
    );
  }
}
