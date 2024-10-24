import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AnnouncementDetailsPage extends StatelessWidget {
  final DatabaseReference announcementsRef =
      FirebaseDatabase.instance.ref('announcements');
  final DatabaseReference adminsRef = FirebaseDatabase.instance.ref('admin');

  AnnouncementDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: screenHeight * 0.08,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Announcements',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.06,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: FutureBuilder<DataSnapshot>(
          future: announcementsRef.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.value == null) {
              return Center(child: Text('No announcements available'));
            }

            final Map<dynamic, dynamic> announcementData =
                snapshot.data!.value as Map<dynamic, dynamic>;
            List<AnnouncementInfo> announcementList = [];

            // Prepare to fetch admin names
            Map<String, String> adminNames = {};

            // Iterate through announcements
            announcementData.forEach((key, value) {
              if (value is Map<dynamic, dynamic>) {
                // Extract admin_id
                String adminId = value['admin_id'] ?? '';
                announcementList.add(AnnouncementInfo(
                  title: value['title'] ?? 'No Title',
                  date: value['date'] ?? 'No Date',
                  details: value['details'] ?? 'No Details',
                  adminId: adminId,
                ));

                // Collect unique admin_ids
                if (!adminNames.containsKey(adminId) && adminId.isNotEmpty) {
                  adminNames[adminId] = ''; // Placeholder for admin name
                }
              }
            });

            // Sort announcements by date (latest first)
            announcementList.sort((a, b) => b.date.compareTo(a.date));

            // Fetch admin names in bulk
            return FutureBuilder<DataSnapshot>(
              future: adminsRef.get(),
              builder: (context, adminSnapshot) {
                if (adminSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (adminSnapshot.hasError) {
                  return Center(child: Text('Error fetching admins'));
                } else if (!adminSnapshot.hasData ||
                    adminSnapshot.data!.value == null) {
                  return Center(child: Text('No admin data available'));
                }

                // Map admin names
                final Map<dynamic, dynamic> adminData =
                    adminSnapshot.data!.value as Map<dynamic, dynamic>;
                adminData.forEach((key, value) {
                  if (value is Map<dynamic, dynamic>) {
                    String adminId = key.toString();
                    String adminName = value['ownerName'] ??
                        'Unknown Admin'; // Fixed to match your structure
                    if (adminNames.containsKey(adminId)) {
                      adminNames[adminId] = adminName;
                    }
                  }
                });

                // Update announcement list with admin names
                for (var announcement in announcementList) {
                  announcement.ownername =
                      adminNames[announcement.adminId] ?? 'Unknown Admin';
                }

                return ListView.builder(
                  itemCount: announcementList.length,
                  itemBuilder: (context, index) {
                    return _buildAnnouncementCard(
                        announcementList[index], screenWidth);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Method to build each announcement card
  Widget _buildAnnouncementCard(
      AnnouncementInfo announcement, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.020,
              horizontal: screenWidth * 0.04,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFD7B3CE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              announcement.title,
              style: TextStyle(
                fontSize: screenWidth * 0.042,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF66123A),
              ),
            ),
          ),
          // Body Section
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.date,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  'Details: ${announcement.details}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  'Added by: ${announcement.ownername}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnnouncementInfo {
  final String title;
  final String date;
  final String details;
  final String adminId; // To store admin ID
  String ownername; // To store admin name

  AnnouncementInfo({
    required this.title,
    required this.date,
    required this.details,
    required this.adminId,
    this.ownername = 'Unknown Admin', // Default value
  });
}
