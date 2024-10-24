import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'addmemeber_form.dart'; // Import the AddMemberForm file

class ResidentsPage extends StatefulWidget {
  const ResidentsPage({super.key});

  @override
  _ResidentsPageState createState() => _ResidentsPageState();
}

class _ResidentsPageState extends State<ResidentsPage> {
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
          loadedResidents.add({
            "id": key, // Store the unique key for deletion
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

  // Delete resident from Firebase
  Future<void> _deleteResident(String id) async {
    await _databaseReference.child(id).remove();
    _fetchResidents(); // Refresh the list after deletion
  }

  // Show confirmation dialog before deletion
  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Member"),
          content: Text("Are you sure you want to delete this member?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                _deleteResident(id).then((_) {
                  Navigator.of(context).pop(); // Close dialog
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ), // Responsive padding
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
                        // Navigate to AddMemberForm screen and wait for result
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMemberForm(
                              onMemberAdded: (newMember) {
                                setState(() {
                                  residents.add(newMember);
                                  filteredResidents = residents;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '  Add Members',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  screenWidth * 0.045, // Responsive font size
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03), // Responsive spacing
            Expanded(
              child: filteredResidents == null || filteredResidents!.isEmpty
                  ? Center(child: Text("No residents found"))
                  : ListView.builder(
                      itemCount: filteredResidents?.length ?? 0,
                      itemBuilder: (context, index) {
                        final resident = filteredResidents![index];
                        final residentId = resident['id'] ?? '';
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              resident['ownerName'] ?? "N/A",
                              style: TextStyle(
                                fontSize: screenWidth * 0.049,
                              ),
                            ),
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
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(residentId),
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
