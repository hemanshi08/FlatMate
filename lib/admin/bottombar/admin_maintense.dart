import 'package:flatmate/admin/admin_dashboard.dart';
import 'package:flatmate/admin/bottombar/admin_complain.dart';
import 'package:flatmate/admin/bottombar/admin_expense.dart';
import 'package:flatmate/data/database_service.dart';
import 'package:flatmate/drawer/contact_details.dart';
import 'package:flatmate/drawer/language.dart';
import 'package:flatmate/drawer/profile.dart';
import 'package:flatmate/drawer/security_details.dart';
import 'package:flutter/material.dart';
import '../../SameScreen/LoginScreen.dart';
import '../../drawer/changepass.dart';
import 'maintense_request_form.dart'; // Ensure this import is present

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  List<Map<String, dynamic>> maintenanceRequests = [];
  bool _isLoading = false;
  List<String> selectedResidents =
      []; // State variable to store selected residents

  @override
  void initState() {
    super.initState();
    _fetchMaintenanceRequests();
  }

  // Function to fetch maintenance requests from the database
  Future<void> _fetchMaintenanceRequests() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      final requests = await DatabaseService()
          .getMaintenanceRequests(); // Fetch data from your service/database
      print(
          'Fetched requests: $requests'); // Log fetched requests for debugging
      setState(() {
        maintenanceRequests = requests; // Assign fetched data to the list
      });
    } catch (e) {
      print('Error fetching maintenance requests: $e');
    } finally {
      setState(() {
        _isLoading = false; // End loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Maintenance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26 * textScaleFactor,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: 60.0,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            iconSize: screenWidth * 0.095,
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: _buildDrawer(screenWidth, screenHeight),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.013,
                    horizontal: screenWidth * 0.06,
                  ),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaintenanceRequestForm(),
                    ),
                  );

                  if (result != null) {
                    _fetchMaintenanceRequests(); // Refresh the list after making a request
                  }
                },
                child: Text(
                  'Make Request',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Maintenance History List
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : maintenanceRequests.isEmpty
                      ? Center(child: Text('No maintenance requests found.'))
                      : ListView.builder(
                          itemCount: maintenanceRequests.length,
                          itemBuilder: (context, index) {
                            final request = maintenanceRequests[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request['date'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                maintenanceCard(
                                  screenWidth,
                                  screenHeight,
                                  textScaleFactor,
                                  request['title'] ?? 'No Title',
                                  '₹${request['amount']}',
                                  request['isPayable'] ?? false,
                                  request['users'] ?? {}, // Pass user data
                                ),
                                SizedBox(height: screenHeight * 0.02),
                              ],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePageA()),
              );
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminComplain()),
              );
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

// Maintenance card widget
Widget maintenanceCard(
  double screenWidth,
  double screenHeight,
  double textScaleFactor,
  String title,
  String amount,
  bool isPayable,
  Map<String, dynamic> users,
) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
    padding: EdgeInsets.all(screenWidth * 0.04),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(screenWidth * 0.03),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // Shadow position
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left icon (circle with checkmark or other indicator)
        Container(
          width: screenWidth * 0.12,
          height: screenWidth * 0.12,
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.check_circle,
            size: screenWidth * 0.08,
            color: Colors.white,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        // Maintenance details (title, amount, date)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                amount,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                '5 July, 2024', // Static date for demo; you should use dynamic data
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        // Cash or Pay button
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     isPayable
        //         ? ElevatedButton(
        //             onPressed: () {
        //               // Handle payment here
        //             },
        //             child: Text('Pay'),
        //           )
        //         : ElevatedButton(
        //             onPressed: () {
        //               showResidentsDialog(users);
        //             },
        //             child: Text('Cash'),
        //           ),
        //   ],
        // ),
      ],
    ),
  );
}

// Show residents dialog
// // void showResidentsDialog(Map<String, dynamic> users) {
// //   List<String> selectedResidents = [];
// //   TextEditingController searchController = TextEditingController();
// //   String searchQuery = '';

// //   showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return StatefulBuilder(
// //         builder: (context, setState) {
// //           List filteredUsers = users.entries
// //               .where((entry) => entry.value
// //                   .toString()
// //                   .toLowerCase()
// //                   .contains(searchQuery.toLowerCase()))
// //               .toList();

// //           return AlertDialog(
// //             title: Column(
// //               children: [
// //                 Text('Residents'),
// //                 TextField(
// //                   controller: searchController,
// //                   decoration: InputDecoration(
// //                     hintText: 'Search by flat no or name',
// //                     prefixIcon: Icon(Icons.search),
// //                   ),
// //                   onChanged: (value) {
// //                     setState(() {
// //                       searchQuery = value;
// //                     });
// //                   },
// //                 ),
// //               ],
// //             ),
// //             content: Container(
// //               width: double.maxFinite,
// //               height: 300, // Limit the height of the dialog box
// //               child: ListView.builder(
// //                 itemCount: filteredUsers.length,
// //                 itemBuilder: (context, index) {
// //                   String residentName = filteredUsers[index].value.toString();
// //                   bool isSelected = selectedResidents.contains(residentName);

// //                   return CheckboxListTile(
// //                     title: Text(residentName),
// //                     value: isSelected,
// //                     onChanged: (bool? value) {
// //                       setState(() {
// //                         if (value == true) {
// //                           selectedResidents.add(residentName);
// //                         } else {
// //                           selectedResidents.remove(residentName);
// //                         }
// //                       });
// //                     },
// //                   );
// //                 },
// //               ),
// //             ),
// //             actions: [
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.of(context).pop(); // Close the dialog
// //                 },
// //                 child: Text('Close'),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   print('Selected Residents: $selectedResidents');
// //                   Navigator.of(context)
// //                       .pop(); // Close the dialog after selection
// //                 },
// //                 child: Text('Submit'),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     },
// //   );
// }
