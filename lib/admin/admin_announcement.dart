import 'package:firebase_database/firebase_database.dart';
import 'package:flatmate/data/database_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  List<Map<String, String>> announcements = [];

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  // Method to fetch announcements from the database
  Future<void> _fetchAnnouncements() async {
    try {
      List<Map<String, String>> fetchedAnnouncements =
          await DatabaseService().fetchAnnouncements();
      setState(() {
        announcements = fetchedAnnouncements;
      });
    } catch (e) {
      print("Error fetching announcements: $e");
    }
  }

  // Method to handle adding a new announcement
  Future<void> _addAnnouncement(Map<String, String> newAnnouncement) async {
    try {
      await DatabaseService().addAnnouncement(newAnnouncement);
      _fetchAnnouncements(); // Refresh the list
    } catch (e) {
      print("Error adding announcement: $e");
    }
  }

  // Method to handle editing an announcement
  Future<void> _editAnnouncement(int index) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAnnouncementScreen(
          addAnnouncement: (updatedAnnouncement) async {
            try {
              await DatabaseService().editAnnouncement(
                announcements[index]["announcement_id"]!,
                updatedAnnouncement,
              );
              _fetchAnnouncements(); // Refresh the list after edit
            } catch (e) {
              print("Error editing announcement: $e");
            }
            Navigator.pop(context);
          },
          initialAnnouncement: announcements[index],
        ),
      ),
    );
  }

  // Method to delete an announcement
  Future<void> _deleteAnnouncement(int index) async {
    try {
      await DatabaseService()
          .deleteAnnouncement(announcements[index]["announcement_id"]!);
      _fetchAnnouncements(); // Refresh the list after delete
    } catch (e) {
      print("Error deleting announcement: $e");
    }
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
          'Announcements',
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
                                  backgroundColor:
                                      Color.fromARGB(255, 60, 206, 235),
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
                                  backgroundColor: Colors.red,
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
  final Future<void> Function(Map<String, String>)? addAnnouncement;
  final Map<String, String>? initialAnnouncement;

  const AddAnnouncementScreen(
      {super.key, this.initialAnnouncement, this.addAnnouncement});

  @override
  _AddAnnouncementScreenState createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime? _selectedDate;
  String? _adminId;

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
            "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAdminId();
    if (widget.initialAnnouncement != null) {
      _titleController.text = widget.initialAnnouncement!["title"]!;
      _dateController.text = widget.initialAnnouncement!["date"]!;
      _detailsController.text = widget.initialAnnouncement!["details"]!;
    }
  }

  Future<void> _loadAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _adminId = prefs.getString('admin_id');
    });
  }

  Future<void> _submitAnnouncement() async {
    if (_formKey.currentState!.validate() && _adminId != null) {
      Map<String, String> newAnnouncement = {
        "admin_id": _adminId!,
        "title": _titleController.text,
        "details": _detailsController.text,
        "date": _dateController.text,
      };

      // Use the passed callback if available
      if (widget.addAnnouncement != null) {
        await widget.addAnnouncement!(newAnnouncement);
      } else {
        // Handle submission here (Firebase logic)
        DatabaseReference _announcementsRef =
            FirebaseDatabase.instance.ref("announcements");
        String newAnnouncementId = _announcementsRef.push().key ?? "";
        newAnnouncement["announcement_id"] = newAnnouncementId;
        await _announcementsRef.child(newAnnouncementId).set(newAnnouncement);
      }

      Navigator.pop(context); // Navigate back after submission
    } else {
      print("Admin ID is null or form validation failed");
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
    var paddingValue = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180,
        backgroundColor: const Color(0xFF06001A),
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 16, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 10),
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
                    onPressed: _submitAnnouncement,
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
