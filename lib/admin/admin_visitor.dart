import 'package:flutter/material.dart';

class VisitorRecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: 60.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'VISITOR LOG',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  VisitorLogCard(
                    type: 'SERVICE',
                    visitorName: 'Joey Tribbani',
                    occupation: 'Maintenance worker',
                    date: '12 Aug, 09:10:00',
                    vehicle: 'GJ-03 5810',
                    departureTime: '10:00:00',
                    wingNo: 'A',
                    flatNo: '101',
                    isSmallScreen: isSmallScreen,
                  ),
                  VisitorLogCard(
                    type: 'Emergency',
                    visitorName: 'Vansh Shah',
                    occupation: 'Medical incidents',
                    date: '12 Aug, 07:30:00',
                    vehicle: 'GJ-03 5910',
                    departureTime: '10:00:00',
                    wingNo: 'B',
                    flatNo: '202',
                    isSmallScreen: isSmallScreen,
                  ),
                  VisitorLogCard(
                    type: 'Emergency',
                    visitorName: 'Preeti Sharma',
                    occupation: 'Fires',
                    date: '12 Aug, 08:10:00',
                    vehicle: 'GJ-03 5850',
                    departureTime: '13:00:00',
                    wingNo: 'C',
                    flatNo: '303',
                    isSmallScreen: isSmallScreen,
                  ),
                  VisitorLogCard(
                    type: 'SERVICE',
                    visitorName: 'Manisha Varma',
                    occupation: 'Cleaner',
                    date: '12 Aug, 08:30:00',
                    vehicle: 'GJ-03 5510',
                    departureTime: '09:00:00',
                    wingNo: 'D',
                    flatNo: '404',
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VisitorLogCard extends StatelessWidget {
  final String type;
  final String visitorName;
  final String occupation;
  final String date;
  final String vehicle;
  final String departureTime;
  final String wingNo;
  final String flatNo;
  final bool isSmallScreen;

  const VisitorLogCard({
    required this.type,
    required this.visitorName,
    required this.occupation,
    required this.date,
    required this.vehicle,
    required this.departureTime,
    required this.wingNo,
    required this.flatNo,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD8AFCC)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: isSmallScreen ? 18 : 20),
                SizedBox(width: 8),
                Text(
                  visitorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '(${occupation})',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: isSmallScreen ? 14 : 16),
                    SizedBox(width: 4),
                    Text(date),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.directions_car, size: isSmallScreen ? 14 : 16),
                    SizedBox(width: 4),
                    Text(vehicle),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.home, size: isSmallScreen ? 14 : 16),
                    SizedBox(width: 4),
                    Text('Wing: $wingNo, Flat: $flatNo'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: isSmallScreen ? 14 : 16),
                    SizedBox(width: 4),
                    Text(departureTime),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
