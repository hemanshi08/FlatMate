import 'package:flutter/material.dart';

class ResidentsPage extends StatefulWidget {
  const ResidentsPage({super.key});

  @override
  _ResidentsPageState createState() => _ResidentsPageState();
}

class _ResidentsPageState extends State<ResidentsPage> {
  // Initial list of residents
  List<Map<String, String>> residents = [
    {
      "flatNo": "A-101",
      "ownerName": "Lakshmi Kant",
      "people": "4",
      "email": "lakshmikant100@gmail.com"
    },
    {
      "flatNo": "A-102",
      "ownerName": "Janki Bhut",
      "people": "5",
      "email": "jankibhut25@gmail.com"
    },
    {
      "flatNo": "A-103",
      "ownerName": "Bhayva Garnara",
      "people": "6",
      "email": "bhavyagarnara@gmail.com"
    },
    {
      "flatNo": "A-104",
      "ownerName": "Hemant Sata",
      "people": "4",
      "email": "hemantsata12@gmail.com"
    },
    {
      "flatNo": "A-201",
      "ownerName": "Gunjan Maru",
      "people": "3",
      "email": "gunjan45@gmail.com"
    },
    {
      "flatNo": "A-202",
      "ownerName": "Bhargrv Garnara",
      "people": "6",
      "email": "bgarnara2013@gmail.com"
    },
  ];

  // List for displaying filtered results
  List<Map<String, String>>? filteredResidents;

  // Controller for the search bar
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredResidents = residents; // Show all residents by default
  }

  // Search function that filters by flat number or owner name
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Residents',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
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
        padding: const EdgeInsets.all(16.0),
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
                  // Underline only
                  borderSide:
                      BorderSide(color: Colors.pink), // Change color as needed
                ),
                enabledBorder: UnderlineInputBorder(
                  // When not focused
                  borderSide:
                      BorderSide(color: Colors.grey), // Change to desired color
                ),
                focusedBorder: UnderlineInputBorder(
                  // When focused
                  borderSide:
                      BorderSide(color: Colors.cyan), // Change to desired color
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
            SizedBox(height: 20),
            // ListView for residents
            Expanded(
              child: ListView.builder(
                itemCount:
                    filteredResidents?.length ?? 0, // Use null-aware access
                itemBuilder: (context, index) {
                  final resident =
                      filteredResidents![index]; // Non-null assertion
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(resident['ownerName']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Flat No: ${resident['flatNo']}'),
                          Text('No. of People: ${resident['people']}'),
                          Text('Email: ${resident['email']}'),
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
