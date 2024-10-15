import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ContactDetailsPage extends StatelessWidget {
  final DatabaseReference adminRef = FirebaseDatabase.instance.ref('admin');

  ContactDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 25.0),
            Expanded(
              child: FutureBuilder<DataSnapshot>(
                future: adminRef.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('Error fetching data: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.value == null) {
                    print('No contact data available');
                    return Center(child: Text('No contact data available'));
                  }

                  final Map<dynamic, dynamic> contactData =
                      snapshot.data!.value as Map<dynamic, dynamic>;
                  print('Contact data fetched: $contactData');
                  List<ContactInfo> contactList = [];

                  contactData.forEach((key, value) {
                    if (value is Map<dynamic, dynamic>) {
                      contactList.add(ContactInfo(
                        name: value['ownerName'] ?? 'N/A',
                        apartmentNumber: value['flatNo'] ?? 'N/A',
                        phoneNumber: value['contactNo'] ?? 'N/A',
                        email: value['email'] ?? 'N/A',
                      ));
                    }
                  });

                  return ListView.builder(
                    itemCount: contactList.length,
                    itemBuilder: (context, index) {
                      return ContactRow(contact: contactList[index]);
                    },
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

  const ContactRow({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Row(
            children: [
              Icon(Icons.phone, color: Colors.blue, size: 18.0),
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
          Row(
            children: [
              Icon(Icons.email, color: Colors.blue, size: 18.0),
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
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
