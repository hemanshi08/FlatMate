import 'package:flutter/material.dart';

class SecurityDetailsPage extends StatelessWidget {
  final List<SecurityInfo> securityList = [
    SecurityInfo(
      name: 'Robert Miller',
      shift: 'Morning Shift',
      phoneNumber: '+1 (555) 111-2233',
      email: 'robert.miller@security.com',
    ),
    SecurityInfo(
      name: 'Alex Turner',
      shift: 'Night Shift',
      phoneNumber: '+1 (555) 222-3344',
      email: 'alex.turner@security.com',
    ),
    SecurityInfo(
      name: 'Sarah Lee',
      shift: 'Evening Shift',
      phoneNumber: '+1 (555) 333-4455',
      email: 'sarah.lee@security.com',
    ),
  ];

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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen
              ? 16.0
              : screenWidth * 0.05, // Adjust padding for responsiveness
          vertical: 24.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Security Details',
                style: TextStyle(
                  fontSize: isSmallScreen ? 22.0 : 26.0, // Responsive text size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 25.0),
            Expanded(
              child: ListView.builder(
                itemCount: securityList.length,
                itemBuilder: (context, index) {
                  return SecurityRow(
                    security: securityList[index],
                    isSmallScreen: isSmallScreen,
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

class SecurityInfo {
  final String name;
  final String shift;
  final String phoneNumber;
  final String email;

  SecurityInfo({
    required this.name,
    required this.shift,
    required this.phoneNumber,
    required this.email,
  });
}

class SecurityRow extends StatelessWidget {
  final SecurityInfo security;
  final bool isSmallScreen;

  SecurityRow({required this.security, required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal:
            isSmallScreen ? 10.0 : 20.0, // Adjust padding for responsiveness
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  security.name,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18.0 : 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 32, 32, 32),
                  ),
                ),
              ),
              Text(
                security.shift,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14.0 : 16.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              Icon(Icons.phone,
                  color: Colors.blue, size: isSmallScreen ? 16.0 : 18.0),
              SizedBox(width: 8.0),
              Text(
                security.phoneNumber,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14.0 : 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.email,
                  color: Colors.blue, size: isSmallScreen ? 16.0 : 18.0),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  security.email,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14.0 : 16.0,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Divider(
            thickness: 1.0,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}

// void main() => runApp(MaterialApp(
//       home: SecurityDetailsPage(),
//     ));
