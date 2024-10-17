import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ResidentsPage extends StatefulWidget {
  const ResidentsPage({super.key});

  @override
  _ResidentsPageState createState() => _ResidentsPageState();
}

class _ResidentsPageState extends State<ResidentsPage> {
  // List of residents fetched from Firebase
  List<Map<String, String>> residents = [];
  List<Map<String, String>>? filteredResidents;

  final TextEditingController _searchController = TextEditingController();
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('residents');

  @override
  void initState() {
    super.initState();
    _fetchResidents(); // Fetch residents from Firebase
  }

  // Fetch residents data from Firebase
  Future<void> _fetchResidents() async {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Map<String, String>> loadedResidents = [];
        data.forEach((key, value) {
          print("Fetched Resident Data: $value"); // Debugging statement
          loadedResidents.add({
            "flatNo": value["flatNo"]?.toString() ?? "N/A",
            "ownerName": value["ownerName"]?.toString() ?? "N/A",
            "people": value["people"]?.toString() ?? "N/A",
            "email": value["email"]?.toString() ?? "N/A",
            "contactNo": value["contactNo"]?.toString() ?? "N/A",
          });
        });
        setState(() {
          residents = loadedResidents;
          filteredResidents = residents; // Display all by default
        });
      } else {
        print("No data available in Firebase");
      }
    });
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: filteredResidents == null || filteredResidents!.isEmpty
                  ? Center(child: Text("No residents found"))
                  : ListView.builder(
                      itemCount: filteredResidents?.length ?? 0,
                      itemBuilder: (context, index) {
                        final resident = filteredResidents![index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(resident['ownerName'] ?? "N/A"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Flat No: ${resident['flatNo'] ?? "N/A"}'),
                                Text(
                                    'No. of People: ${resident['people'] ?? "N/A"}'),
                                Text('Email: ${resident['email'] ?? "N/A"}'),
                                Text(
                                    'Contact No: ${resident['contactNo'] ?? "N/A"}'),
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
