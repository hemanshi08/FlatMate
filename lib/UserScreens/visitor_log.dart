import 'package:flutter/material.dart';

class VisitorLogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Visitor'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VISITOR LOG',
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
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
                    isSmallScreen: isSmallScreen,
                  ),
                  VisitorLogCard(
                    type: 'Emergency',
                    visitorName: 'Vansh Shah',
                    occupation: 'Medical incidents',
                    date: '12 Aug, 07:30:00',
                    vehicle: 'GJ-03 5910',
                    departureTime: '10:00:00',
                    isSmallScreen: isSmallScreen,
                  ),
                  VisitorLogCard(
                    type: 'Emergency',
                    visitorName: 'Preeti Sharma',
                    occupation: 'Fires',
                    date: '12 Aug, 08:10:00',
                    vehicle: 'GJ-03 5850',
                    departureTime: '13:00:00',
                    isSmallScreen: isSmallScreen,
                  ),
                  VisitorLogCard(
                    type: 'SERVICE',
                    visitorName: 'Manisha Varma',
                    occupation: 'Cleaner',
                    date: '12 Aug, 08:30:00',
                    vehicle: 'GJ-03 5510',
                    departureTime: '09:00:00',
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
  final bool isSmallScreen;

  const VisitorLogCard({
    required this.type,
    required this.visitorName,
    required this.occupation,
    required this.date,
    required this.vehicle,
    required this.departureTime,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Removed background color and set same font color for all labels
            Text(
              type,
              style: TextStyle(
                color: Colors.black, // Set a uniform color for all labels
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              visitorName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            SizedBox(height: 4),
            Text(occupation),
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
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: isSmallScreen ? 14 : 16),
                SizedBox(width: 4),
                Text(departureTime),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
