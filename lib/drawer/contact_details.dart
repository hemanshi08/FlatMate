import 'package:flutter/material.dart';

class ContactDetailsPage extends StatelessWidget {
  final List<ContactInfo> contactList = [
    ContactInfo(
      name: 'John Doe',
      apartmentNumber: 'A101',
      phoneNumber: '+1 (123) 456-7890',
      email: 'johndoe@example.com',
    ),
    ContactInfo(
      name: 'Jane Smith',
      apartmentNumber: 'B202',
      phoneNumber: '+1 (987) 654-3210',
      email: 'janesmith@example.com',
    ),
    ContactInfo(
      name: 'Michael Johnson',
      apartmentNumber: 'C303',
      phoneNumber: '+1 (555) 123-4567',
      email: 'michael.j@example.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   'Contact Details',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 26,
        //     letterSpacing: 1,
        //   ),
        // ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title centered
            Center(
              child: Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 25.0), // Space below the title
            Expanded(
              child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  return ContactRow(contact: contactList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfo {
  final String name;
  final String apartmentNumber;
  final String phoneNumber;
  final String email;

  ContactInfo({
    required this.name,
    required this.apartmentNumber,
    required this.phoneNumber,
    required this.email,
  });
}

class ContactRow extends StatelessWidget {
  final ContactInfo contact;

  ContactRow({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 10.0, horizontal: 10), // Space between rows
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Name and Apartment Number in Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  contact.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 32, 32, 32),
                  ),
                ),
              ),
              Text(
                'Apt: ${contact.apartmentNumber}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.0),
          // Phone number
          Row(
            children: [
              Icon(Icons.phone,
                  color: Colors.blue, size: 18.0), // Smaller icon size
              SizedBox(width: 8.0),
              Text(
                contact.phoneNumber,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          // Email
          Row(
            children: [
              Icon(Icons.email,
                  color: Colors.blue, size: 18.0), // Smaller icon size
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  contact.email,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Divider(
            thickness: 1.0,
            color: Colors.grey[300], // Divider to separate contacts
          ),
        ],
      ),
    );
  }
}

// void main() => runApp(MaterialApp(
//       home: ContactDetailsPage(),
//     ));
