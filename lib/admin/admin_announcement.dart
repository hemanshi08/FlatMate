import 'package:flutter/material.dart';

class AnnouncementScreen extends StatefulWidget {
  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  List<Map<String, String>> announcements = [
    {
      "title": "Community Events",
      "date": "26 Jul 2024",
      "details":
          "Join us for a BBQ in the courtyard! \nTime: 4:00 PM - 6:00 PM\nDetails: Free food, games, and a chance to meet your neighbors."
    },
    {
      "title": "Holiday Party",
      "date": "12 May 2024",
      "details":
          "Time: 6:00 PM - 9:00 PM\nDetails: Celebrate with us in the lobby.\nSnacks and drinks provided."
    },
  ];

  void _editAnnouncement(int index) {
    // Logic for editing announcement
  }

  void _deleteAnnouncement(int index) {
    setState(() {
      announcements.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement'),
        backgroundColor: const Color(0xFF06001A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white, // Background color for the card
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFD7B3CE), // Pink header color
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcements[index]["title"]!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF66123A),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          announcements[index]["date"]!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      announcements[index]["details"]!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _editAnnouncement(index),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF66123A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text('EDIT'),
                      ),
                      ElevatedButton(
                        onPressed: () => _deleteAnnouncement(index),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text('DELETE'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Adding space at the bottom
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: AnnouncementScreen(),
//   ));
// }
