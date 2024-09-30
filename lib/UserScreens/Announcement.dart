import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  // Sample announcements
  final List<Map<String, String>> announcements = [
    {
      "title": "Community Events",
      "date": "26 Jul 2024",
      "time": "4:00 PM - 6:00 PM",
      "details":
          "Join us for a BBQ in the courtyard! Free food, games, and a chance to meet your neighbors."
    },
    {
      "title": "Holiday Party",
      "date": "12 May 2024",
      "time": "6:00 PM - 9:00 PM",
      "details": "Celebrate with us in the lobby. Snacks and drinks provided."
    },
    {
      "title": "Repair Notice",
      "date": "1 May 2024",
      "time": "1:00 PM - 4:00 PM",
      "details":
          "HVAC system repair in Building A. Possible temperature fluctuations. Contact: (123) 456-7890."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final screenHeight =
        MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Announcement',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.06, // Responsive font size
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: screenHeight * 0.08, // Responsive height
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
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: ListView.builder(
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return _buildAnnouncementCard(
              title: announcement["title"]!,
              date: announcement["date"]!,
              time: announcement["time"]!,
              details: announcement["details"]!,
              highlight: index == 2, // Highlight the third item (Repair Notice)
              screenWidth: screenWidth, // Pass screen width for responsiveness
            );
          },
        ),
      ),
    );
  }

  // Method to build each announcement card
  Widget _buildAnnouncementCard({
    required String title,
    required String date,
    required String time,
    required String details,
    required double screenWidth,
    bool highlight = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: screenWidth * 0.03), // Responsive vertical margin
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section (Pink background with title)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.020,
              horizontal: screenWidth * 0.04,
            ), // Responsive padding
            decoration: BoxDecoration(
              color: Color(0xFFD7B3CE), // Pink header color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.042, // Responsive font size
                fontWeight: FontWeight.bold,
                color: const Color(0xFF66123A),
              ),
            ),
          ),
          // Body Section (White background with details)
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01), // Responsive spacing
                Text(
                  'Time: $time',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    color: Colors.black87,
                  ),
                ),
                // SizedBox(height: screenWidth * 0.01), // Responsive spacing
                Text(
                  'Details: $details',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    color: Colors.black87,
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
