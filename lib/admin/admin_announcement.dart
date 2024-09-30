import 'package:flutter/material.dart';

class AnnouncementScreen extends StatefulWidget {
  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  List<Map<String, String>> announcements = [
    {
      "title": "Community Events",
      "date": "07/26/2024", // Changed date format
      "details":
          "Join us for a BBQ in the courtyard! \nTime: 4:00 PM - 6:00 PM\nDetails: Free food, games, and a chance to meet your neighbors."
    },
    {
      "title": "Holiday Party",
      "date": "08/26/2024", // Changed date format
      "details":
          "Time: 6:00 PM - 9:00 PM\nDetails: Celebrate with us in the lobby.\nSnacks and drinks provided."
    },
  ];

  // Method to handle adding a new announcement
  void _addAnnouncement(Map<String, String> newAnnouncement) {
    setState(() {
      announcements.add(newAnnouncement);
    });
  }

  void _editAnnouncement(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAnnouncementScreen(
          addAnnouncement: (updatedAnnouncement) {
            setState(() {
              announcements[index] = updatedAnnouncement;
            });
            Navigator.pop(context);
          },
          initialAnnouncement: announcements[index],
        ),
      ),
    );
  }

  void _deleteAnnouncement(int index) {
    setState(() {
      announcements.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    double paddingValue = screenWidth * 0.04;
    double fontSizeTitle = screenWidth * 0.035;
    double fontSizeDetails = screenWidth * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Announcement',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
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
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Column(
          children: [
            // Add Announcement button with custom style
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAnnouncementScreen(
                        addAnnouncement: _addAnnouncement,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 60, 206, 235),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.011,
                    horizontal: screenHeight * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Announcement',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: const Color(0xFF06001A),
                      ),
                    ),
                    Icon(
                      Icons.add,
                      size: screenWidth * 0.06,
                      color: const Color(0xFF06001A),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: ListView.builder(
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(paddingValue * 0.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8AFCC),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                announcements[index]["title"]!,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF66123A),
                                  letterSpacing: 0.6,
                                ),
                              ),
                              Text(
                                announcements[index]["date"]!,
                                style: TextStyle(
                                  fontSize: fontSizeDetails,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF66123A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(paddingValue),
                          child: Text(
                            announcements[index]["details"]!,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.black,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: paddingValue),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () => _editAnnouncement(index),
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 60, 206, 235),
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight *
                                        0.005, // Decreased vertical padding
                                    horizontal: screenWidth * 0.03,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  'EDIT',
                                  style: TextStyle(
                                    color: const Color(0xFF06001A),
                                    fontSize: screenWidth * 0.034,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _deleteAnnouncement(index),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight *
                                        0.005, // Decreased vertical padding
                                    horizontal: screenWidth * 0.03,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  'DELETE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w800,
                                    fontSize: screenWidth * 0.034,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
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

// New screen to add or edit announcement
class AddAnnouncementScreen extends StatefulWidget {
  final Function(Map<String, String>) addAnnouncement;
  final Map<String, String>? initialAnnouncement;

  AddAnnouncementScreen(
      {required this.addAnnouncement, this.initialAnnouncement});

  @override
  _AddAnnouncementScreenState createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}"; // Format as MM/DD/YYYY
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialAnnouncement != null) {
      _titleController.text = widget.initialAnnouncement!["title"]!;
      _dateController.text = widget.initialAnnouncement!["date"]!;
      _detailsController.text = widget.initialAnnouncement!["details"]!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    double paddingValue = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180, // Custom toolbar height
        backgroundColor: const Color(0xFF06001A),
        automaticallyImplyLeading:
            false, // Disable default back button behavior
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 16, top: 50), // Adjust padding
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
              SizedBox(height: 10), // Add some space between the icon and title
              Center(
                child: Text(
                  "Announcements",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Spacer(), // Adjust spacing
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(paddingValue),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _detailsController,
                  decoration: InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter details';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.addAnnouncement({
                          "title": _titleController.text,
                          "date": _dateController.text,
                          "details": _detailsController.text,
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD8AFCC),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
