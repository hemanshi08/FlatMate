import 'package:flutter/material.dart';

class ResidentsPage extends StatefulWidget {
  @override
  _ResidentsPageState createState() => _ResidentsPageState();
}

class _ResidentsPageState extends State<ResidentsPage> {
  // Initial list of residents
  List<Map<String, String>> residents = [
    {
      "flatNo": "A-101",
      "ownerName": "Lakshmi Patel",
      "people": "4",
      "email": "lakshmi@gmail.com"
    },
    {
      "flatNo": "A-102",
      "ownerName": "Amit Shah",
      "people": "6",
      "email": "amitshah@gmail.com"
    },
    {
      "flatNo": "A-103",
      "ownerName": "Bharat Sharma",
      "people": "5",
      "email": "bharatsharma@gmail.com"
    },
    {
      "flatNo": "A-104",
      "ownerName": "Hemant Sinha",
      "people": "3",
      "email": "hemantsinha@gmail.com"
    },
    {
      "flatNo": "A-105",
      "ownerName": "Gurpreet Marya",
      "people": "5",
      "email": "gurpreet@gmail.com"
    },
    {
      "flatNo": "A-106",
      "ownerName": "Raghu Samora",
      "people": "4",
      "email": "raghusamora@gmail.com"
    },
  ];

  // List for displaying filtered results
  List<Map<String, String>>? filteredResidents;

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              onChanged: (value) => _searchResidents(value),
              decoration: InputDecoration(
                hintText: 'Search by flat no. or owner name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
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

// void main() => runApp(MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//       home: ResidentsPage(),
//     ));