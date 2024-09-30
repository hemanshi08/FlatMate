import 'package:flutter/material.dart';

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

  // Sample data for paid and unpaid maintenance lists
  final List<Map<String, String>> paidList = [
    {'flat': 'A-401', 'name': 'Hemanshi Garnara'},
    {'flat': 'C-201', 'name': 'Kashish Koshiya'},
    {'flat': 'B-604', 'name': 'Ishan Mishra'},
    {'flat': 'A-804', 'name': 'Himesh Vaghela'},
  ];

  final List<Map<String, String>> unpaidList = [
    {'flat': 'D-302', 'name': 'Priya Patel'},
    {'flat': 'E-103', 'name': 'Rahul Mehta'},
    {'flat': 'F-401', 'name': 'Anjali Shah'},
  ];

  @override
  void initState() {
    super.initState();
    // Initially, the displayed list is the paid list
    displayedList = paidList;
  }

  void updateSearchResults(String query) {
    List<Map<String, String>> originalList =
        isPaidSelected ? paidList : unpaidList;

    if (query.isEmpty) {
      setState(() {
        displayedList = originalList;
      });
    } else {
      setState(() {
        displayedList = originalList.where((element) {
          return element['flat']!.toLowerCase().contains(query.toLowerCase()) ||
              element['name']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
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
              onChanged:
                  updateSearchResults, // Update list when search input changes
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: screenWidth * 0.07, // Increased size for bold effect
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            // Paid / Unpaid toggle buttons
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
                          isPaidSelected = false;
                          displayedList = unpaidList;
                          updateSearchResults(searchController
                              .text); // Apply search to unpaid list
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isPaidSelected == false
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
                          isPaidSelected = true;
                          displayedList = paidList;
                          updateSearchResults(searchController
                              .text); // Apply search to paid list
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isPaidSelected == true
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

            // List of maintenance records with shadows
            Expanded(
              child: ListView.builder(
                itemCount: displayedList.length,
                itemBuilder: (context, index) {
                  final data = displayedList[index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2), // Shadow position
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            data['flat']!,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04 * textScaleFactor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            data['name']!,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04 * textScaleFactor,
                            ),
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
