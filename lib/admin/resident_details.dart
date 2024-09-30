import 'package:flutter/material.dart';
import 'addmemeber_form.dart'; // Import the AddMemberForm file

class ResidentsPage extends StatefulWidget {
  @override
  _ResidentsPageState createState() => _ResidentsPageState();
}

class _ResidentsPageState extends State<ResidentsPage> {
  List<Map<String, String>> residents = [
    {
      "flatNo": "A-101",
      "ownerName": "Lakshmi Kant",
      "people": "4",
      "email": "lakshmikant100@gmail.com",
      "contactNo": "9876543210",
    },
    {
      "flatNo": "A-102",
      "ownerName": "Janki Bhut",
      "people": "5",
      "email": "jankibhut25@gmail.com",
      "contactNo": "1234567890",
    },
    {
      "flatNo": "A-103",
      "ownerName": "Bhayva Garnara",
      "people": "6",
      "email": "bhavyagarnara@gmail.com",
      "contactNo": "0987654321",
    },
    {
      "flatNo": "A-104",
      "ownerName": "Hemant Sata",
      "people": "4",
      "email": "hemantsata12@gmail.com",
      "contactNo": "1122334455",
    },
    {
      "flatNo": "A-201",
      "ownerName": "Gunjan Maru",
      "people": "3",
      "email": "gunjan45@gmail.com",
      "contactNo": "5566778899",
    },
    {
      "flatNo": "A-202",
      "ownerName": "Bhargrv Garnara",
      "people": "6",
      "email": "bgarnara2013@gmail.com",
      "contactNo": "2233445566",
    },
  ];

  List<Map<String, String>>? filteredResidents;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredResidents = residents; // Show all residents by default
  }

  void _searchResidents(String query) {
    final results = residents.where((resident) {
      final flatNo = resident['flatNo']?.toLowerCase() ?? '';
      final ownerName = resident['ownerName']?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return flatNo.contains(searchQuery) || ownerName.contains(searchQuery);
    }).toList();

    setState(() {
      filteredResidents = results;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchResidents('');
  }

  void _addMember(Map<String, String> newMember) {
    setState(() {
      residents.add(newMember);
      filteredResidents = residents; // Refresh the displayed list
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Residents',
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
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              // Open drawer or menu
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar with underline
            TextField(
              controller: _searchController,
              onChanged: _searchResidents,
              decoration: InputDecoration(
                hintText: 'Search by flat no. or owner name',
                prefixIcon: Icon(Icons.search, color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.black),
                  onPressed: _clearSearch,
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
            SizedBox(height: screenHeight * 0.03), // Responsive spacing
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue, // Set the background color
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddMemberForm(onMemberAdded: _addMember),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '  Add Members',
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontSize:
                                  screenWidth * 0.045, // Responsive font size
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black, // Icon color
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03), // Responsive spacing
            // ListView for residents
            Expanded(
              child: ListView.builder(
                itemCount: filteredResidents?.length ?? 0,
                itemBuilder: (context, index) {
                  final resident = filteredResidents![index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        resident['ownerName']!,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05, // Responsive font size
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'Flat No: ${resident['flatNo']}',
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No. of People: ${resident['people']}',
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Email: ${resident['email']}',
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Contact No: ${resident['contactNo']}', // Display contact number
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.004),
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
