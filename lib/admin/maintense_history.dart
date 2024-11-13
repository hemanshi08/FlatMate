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

  // Static data
  List<Map<String, String>> paid = [
    {'flat': 'A_101', 'name': 'Kashish'},
    {'flat': 'A_102', 'name': 'Hemanshi Garnara'},
  ];
  List<Map<String, String>> unpaid = [
    {'flat': 'A_103', 'name': 'Hemanshi'},
  ];
  List<Map<String, String>> displayedList = [];

  @override
  void initState() {
    super.initState();
    updateDisplayedList();
    searchController.addListener(() {
      updateSearchResults(searchController.text);
    });
  }

  void updateDisplayedList() {
    setState(() {
      displayedList = isPaidSelected ? paid : unpaid;
    });
  }

  void updateSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedList = isPaidSelected ? paid : unpaid;
      } else {
        displayedList = (isPaidSelected ? paid : unpaid).where((element) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Maintense History',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.065, // Responsive font size
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: 60.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                          updateDisplayedList();
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
                          updateDisplayedList();
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
