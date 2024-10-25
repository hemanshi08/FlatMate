import 'package:firebase_database/firebase_database.dart';
import 'package:flatmate/UserScreens/complain_first.dart';
import 'package:flatmate/UserScreens/payment_screen.dart';
import 'package:flatmate/UserScreens/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:flatmate/UserScreens/user_dashboard.dart';
import 'package:flatmate/drawer/contact_details.dart';
import 'package:flatmate/drawer/language.dart';
import 'package:flatmate/drawer/profile.dart';
import 'package:flatmate/drawer/security_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

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

          // Fetch owner details and payment info for each request
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
                request['isPayable'] = false; // User has already paid
                request['canDownloadReceipt'] =
                    true; // User can download receipt

                // Fetch the receipt URL from the userPayment
                request['receipt_url'] = userPayment['receipt_url'] ?? '';
                if (request['receipt_url'].isNotEmpty) {
                  print(
                      'Fetched receipt URL: ${request['receipt_url']} for request ID: ${request['requestId']}');
                } else {
                  print(
                      'Receipt URL is empty for request ID: ${request['requestId']}');
                }
              }
            } else {
              print(
                  'No payment found for user ID: $currentUserId in request ID: ${request['requestId']}');
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

  Future<void> downloadReceipt(
      String paymentId, String requestId, String userId) async {
    try {
      // Fetch receipt URL
      String? receiptUrl = await _getReceiptUrl(requestId, userId);

      if (receiptUrl != null && receiptUrl.isNotEmpty) {
        // Download the PDF receipt
        String fileName = "maintenance_receipt_$paymentId.pdf";
        await downloadPdf(receiptUrl, fileName);
      } else {
        print('Receipt URL not found for paymentId: $paymentId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receipt not available for this payment')),
        );
      }
    } catch (e) {
      print('Error downloading receipt: $e');
    }
  }

// Method to get the receipt URL based on requestId and userId
  Future<String?> _getReceiptUrl(String requestId, String userId) async {
    try {
      final DataSnapshot snapshot = await FirebaseDatabase.instance
          .ref()
          .child('maintenance_requests/$requestId/payments/$userId')
          .get();

      if (snapshot.exists) {
        final paymentData = snapshot.value as Map<dynamic, dynamic>;
        return paymentData['receipt_url'] as String?;
      } else {
        print(
            'No payment found for request ID: $requestId and user ID: $userId');
      }
    } catch (e) {
      print('Error fetching receipt URL: $e');
    }
    return null;
  }

// Method to download PDF
  Future<void> downloadPdf(String url, String fileName) async {
    // Request permission before downloading
    await _requestPermission();

    try {
      Dio dio = Dio();
      String dir = (await getApplicationDocumentsDirectory()).path;

      // Create the directory if it doesn't exist
      Directory directory = Directory(dir);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Full file path where the PDF will be saved
      String filePath = '$dir/$fileName';

      // Start the download
      await dio.download(url, filePath);
      print('Download completed: $filePath');

      // Optionally, show a success message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Downloaded $fileName')));

      // Open the downloaded PDF
      OpenFile.open(filePath); // Use OpenFile to open the PDF
    } catch (e) {
      print('Error downloading PDF: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error downloading PDF: $e')));
          
    }
  }

// Request storage permission
  Future<void> _requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
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
                  request['receipt_url'] ?? '',
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
    String receiptUrl, // Add receiptUrl as a parameter
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
                    onPressed: () async {
                      // Fetch SharedPreferences instance
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      // Retrieve the current user ID
                      String? currentUserId = prefs.getString('user_id');

                      if (currentUserId != null) {
                        // Use the receiptUrl parameter directly
                        // Assume paymentId is the requestId or you can get it from the context
                        String paymentId =
                            requestId; // Change this to the correct payment ID

                        // Get the receipt URL using the correct method
                        String? receiptUrl = await _getReceiptUrl(
                            paymentId, currentUserId); // Use _getReceiptUrl

                        if (receiptUrl != null && receiptUrl.isNotEmpty) {
                          print('Downloading PDF from URL: $receiptUrl');
                          await downloadPdf(
                            receiptUrl,
                            'receipt_${paymentId}.pdf',
                          );
                        } else {
                          print(
                              'Receipt URL is empty for payment ID: $paymentId');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Receipt URL not found.')),
                          );
                        }
                      } else {
                        print('No user ID found in SharedPreferences.');
                      }
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
