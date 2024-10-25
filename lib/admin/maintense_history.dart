import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MaintenanceHistoryScreen extends StatefulWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  State<MaintenanceHistoryScreen> createState() =>
      _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends State<MaintenanceHistoryScreen> {
  bool isPaidSelected = true;
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> displayedList = [];
  List<Map<String, String>> allEntries = []; // Store all entries for searching

  // Firebase Database reference
  final database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fetchMaintenanceData();

    // Update displayed list when search text changes
    searchController.addListener(() {
      updateSearchResults(searchController.text);
    });
  }

  Future<Map<String, String>> fetchResidentsData() async {
    try {
      DatabaseEvent event = await database.child('residents').once();
      print("Residents Event: ${event.snapshot.value}"); // Debug log

      if (event.snapshot.exists) {
        Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          Map<String, String> residentsMap = {};
          data.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              String userId = key.toString();
              // Check if keys exist before accessing their values
              String flatNo = value.containsKey('flatNo')
                  ? value['flatNo']
                  : 'Unknown Flat';
              String ownerName = value.containsKey('ownerName')
                  ? value['ownerName']
                  : 'Unknown Owner';
              residentsMap[userId] = '$flatNo,$ownerName';
            }
          });
          return residentsMap;
        } else {
          print("No data found for residents.");
        }
      } else {
        print("Snapshot does not exist for residents.");
      }
    } catch (e) {
      print("Error fetching residents data: $e");
    }
    return {};
  }

  Future<void> fetchMaintenanceData() async {
    try {
      Map<String, String> residentsMap = await fetchResidentsData();
      print("Residents Data: $residentsMap"); // Debug log

      DatabaseEvent event = await database.child('maintenance_requests').once();
      print("Maintenance Requests Data: ${event.snapshot.value}"); // Debug log

      Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<Map<String, String>> paid = [];
        List<Map<String, String>> unpaid = [];

        data.forEach((key, request) {
          if (request is Map<dynamic, dynamic> &&
              request.containsKey('payments') &&
              request['payments'] is Map) {
            Map<dynamic, dynamic> payments = request['payments'];

            payments.forEach((paymentKey, payment) {
              if (payment is Map<dynamic, dynamic> &&
                  payment.containsKey('payment_status')) {
                String status = payment['payment_status'] as String;
                String userId = payment['user_id'] ??
                    ''; // Assuming user_id is stored in payment
                String flatAndName =
                    residentsMap[userId] ?? 'Unknown Flat, Unknown Owner';
                List<String> flatAndOwnerDetails = flatAndName.split(',');

                String flat = flatAndOwnerDetails[0];
                String name = flatAndOwnerDetails[1];

                if (status == 'Paid') {
                  paid.add({'flat': flat, 'name': name});
                } else {
                  unpaid.add({'flat': flat, 'name': name});
                }
              }
            });
          }
        });

        allEntries =
            isPaidSelected ? paid : unpaid; // Store all entries for searching
        print(
            "Fetched Entries: $allEntries"); // Debug log to check fetched entries
        setState(() {
          displayedList = allEntries;
        });
      } else {
        print("No data found in Firebase for maintenance_requests.");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void updateSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedList =
            allEntries; // Reset to all entries when the query is empty
      } else {
        displayedList = allEntries.where((element) {
          return element['flat']!.toLowerCase().contains(query.toLowerCase()) ||
              element['name']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void clearSearch() {
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06001A),
        title: Text(
          'Maintenance History',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.06,
            letterSpacing: 1,
          ),
        ),
        toolbarHeight: 60.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.01),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by flat no. or owner name',
                prefixIcon: Icon(Icons.search, color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.black),
                  onPressed: clearSearch,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: 16.0,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              padding: const EdgeInsets.all(4),
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
                          isPaidSelected = true;
                          fetchMaintenanceData(); // Refresh list
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isPaidSelected
                              ? const Color(0xFFD8AFCC)
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Paid Maintenance",
                            style: TextStyle(
                              fontSize: screenWidth * 0.041,
                              color: const Color(0xFF66123A),
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
                          isPaidSelected = false;
                          fetchMaintenanceData(); // Refresh list
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isPaidSelected
                              ? const Color(0xFFD8AFCC)
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Unpaid Maintenance",
                            style: TextStyle(
                              fontSize: screenWidth * 0.041,
                              color: const Color(0xFF66123A),
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
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: displayedList.isEmpty
                  ? Center(
                      child: Text(
                        "No records found.",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: displayedList.length,
                      itemBuilder: (context, index) {
                        final data = displayedList[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                                horizontal: screenWidth * 0.05),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.04),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Flat No: ${data['flat']}",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Owner: ${data['name']}",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  isPaidSelected
                                      ? Icons.check_circle
                                      : Icons.warning,
                                  color: isPaidSelected
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
