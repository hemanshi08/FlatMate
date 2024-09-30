import 'package:flutter/material.dart';

void main() => runApp(ComplaintsApp());

class ComplaintsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ComplaintsScreen(),
    );
  }
}

class ComplaintsScreen extends StatefulWidget {
  @override
  _ComplaintsScreenState createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  int selectedIndex = 0;

  // Function to open the complaint form
  void _openComplaintForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06001A),
        title: Text("Complains",
            style: TextStyle(
              color: Colors.white,
            )),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: const Color(0xFF06001A),
            ),
            onPressed: () {},
          )
        ],
        toolbarHeight: 60.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43DBF8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _openComplaintForm,
              icon: Icon(
                Icons.add,
                color: const Color(0xFF06001A),
              ),
              label: Text(
                "Add Complains",
                style: TextStyle(
                  color: const Color(0xFF06001A),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF66123A), width: 2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedIndex == 0
                              ? const Color(0xFFD8AFCC)
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Solved Complains",
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedIndex == 0
                                  ? const Color(0xFF66123A)
                                  : const Color(0xFF66123A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedIndex == 1
                              ? const Color(0xFFD8AFCC)
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Unsolved Complains",
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedIndex == 1
                                  ? const Color(0xFF66123A)
                                  : const Color(0xFF66123A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: selectedIndex == 0
                ? ComplaintsListView(
                    isSolved: true,
                    onComplaintSelected: (complaint) {
                      _showComplaintDetails(context, complaint);
                    },
                  )
                : ComplaintsListView(
                    isSolved: false,
                    onComplaintSelected: (complaint) {
                      _showComplaintDetails(context, complaint);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Corresponds to "Announcement" tab
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), label: 'Maintenance'),
          BottomNavigationBarItem(
              icon: Icon(Icons.announcement), label: 'Announcement'),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Expense List'),
        ],
      ),
    );
  }

  // Show Complaint Details Dialog
  void _showComplaintDetails(
      BuildContext context, Map<String, String> complaint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      complaint['title']!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  complaint['date']!,
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  complaint['description']!,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ComplaintFormScreen extends StatefulWidget {
  @override
  _ComplaintFormScreenState createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _wingFlatController = TextEditingController();
  final _complaintDescriptionController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ownerNameController.dispose();
    _wingFlatController.dispose();
    _complaintDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180, // Keep your toolbar height as you wanted
        backgroundColor: const Color(0xFF06001A),
        automaticallyImplyLeading:
            false, // Disable default back button behavior
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(
              left: 16, top: 50), // Adjust the left and top padding as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Arrow Icon
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // Title
              SizedBox(
                height: 10,
              ), // This pushes the title towards the bottom
              Center(
                child: Text(
                  "Complain Form",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Spacer(), // Optional: Adjust the spacing between the title and other elements if needed
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Owner Name Field
              TextFormField(
                controller: _ownerNameController,
                decoration: InputDecoration(
                  labelText: 'Owner Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Date Picker Field
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: _selectedDate == null
                          ? 'Select Date & Time'
                          : _selectedDate.toString(),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Wing-Flat Number Field
              TextFormField(
                controller: _wingFlatController,
                decoration: InputDecoration(
                  labelText: 'Wing - Flat No',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your wing-flat number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Complaint Description Field
              TextFormField(
                controller: _complaintDescriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Complaint Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your complaint';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Submit form
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8AFCC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: const Color(0xFF66123A),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComplaintsListView extends StatelessWidget {
  final bool isSolved;
  final Function(Map<String, String>) onComplaintSelected;

  ComplaintsListView(
      {required this.isSolved, required this.onComplaintSelected});

  @override
  Widget build(BuildContext context) {
    // Example data, replace with your actual data
    final complaints = [
      {
        'title': isSolved ? 'Solved Complaint 1' : 'Unsolved Complaint 1',
        'date': '2024-09-23',
        'description': 'This is a description of the complaint.',
      },
      {
        'title': isSolved ? 'Solved Complaint 2' : 'Unsolved Complaint 2',
        'date': '2024-09-23',
        'description': 'This is a description of the complaint.',
      },
    ];

    return ListView.builder(
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final complaint = complaints[index];
        return Card(
          elevation: 4, // Elevation adds a shadow effect
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: ListTile(
            title: Text(complaint['title']!),
            subtitle: Text(complaint['date']!),
            onTap: () {
              onComplaintSelected(complaint);
            },
          ),
        );
      },
    );
  }
}
