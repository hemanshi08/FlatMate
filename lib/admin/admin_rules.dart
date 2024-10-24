import 'package:flatmate/data/database_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRulesScreen extends StatefulWidget {
  const AdminRulesScreen({super.key});

  @override
  _AdminRulesScreenState createState() => _AdminRulesScreenState();
}

class _AdminRulesScreenState extends State<AdminRulesScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _ruleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> rules = [];
  String? currentAdminOwnerName; // To hold the current admin's owner name

  @override
  void initState() {
    super.initState();
    _fetchRules();
    _getAdminownerNameFromPreferences(); // Fetch the admin ownerName from SharedPreferences
  }

  Future<void> testRetrieveAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminId = prefs.getString('admin_id');
    print("Test retrieved Admin ID: $adminId");
  }

  // Helper function to get the admin ownerName from SharedPreferences
  Future<void> _getAdminownerNameFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminId = prefs.getString('admin_id'); // Fetching admin ID

    print(
        "Retrieved Admin ID: $adminId"); // This should not be null if saved properly

    if (adminId != null) {
      String? ownerName =
          await _databaseService.getOwnerNameFromAdminId(adminId);
      if (ownerName != null) {
        setState(() {
          currentAdminOwnerName = ownerName; // Update the owner name state
        });
      }
    } else {
      print("Admin ID is null. Please log in again."); // Handle null case
    }
  }

  // Helper function for responsive font size
  double getResponsiveFontSize(double screenWidth, double multiplier,
      {double minSize = 10.0}) {
    double calculatedSize = screenWidth * multiplier;
    return calculatedSize < minSize ? minSize : calculatedSize;
  }

  // Fetch rules from Firebase including the "addedBy" field (admin name)
  Future<void> _fetchRules() async {
    List<Map<String, dynamic>> fetchedRules =
        await _databaseService.fetchRules();
    setState(() {
      rules = fetchedRules;
    });
  }

  // Add rule through the DatabaseService with owner name
  Future<void> _addRule() async {
    if (_ruleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? adminId = prefs.getString('admin_id'); // Corrected key to match

      if (adminId != null) {
        // Fetch the owner's name based on the admin ID
        String? ownerName = await _databaseService
            .getOwnerNameFromAdminId(adminId); // Pass the adminId

        if (ownerName != null) {
          try {
            // Add the rule with the owner name
            await _databaseService.addRule(
              _ruleController.text,
              _descriptionController.text,
              ownerName, // Pass the owner's name
            );

            // Clear the input fields
            _ruleController.clear();
            _descriptionController.clear();
            // Refresh the list after adding a rule
            await _fetchRules();
            // Close the dialog only after successful addition
            Navigator.of(context).pop();
          } catch (error) {
            // Handle any errors that occur during adding the rule
            print("Error adding rule: $error");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to add rule: $error")),
            );
          }
        } else {
          print("Owner name is null.");
        }
      } else {
        print(
            "Admin ID is null."); // This should now print null if the key is mismatched
      }
    } else {
      print("Rule title or description is empty.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a rule title and description.")),
      );
    }
  }

  // Edit rule using DatabaseService with owner name
  Future<void> _editRule(int index) async {
    String ruleId = rules[index]['rule_id']!;
    if (_ruleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        currentAdminOwnerName != null) {
      await _databaseService.editRule(
        ruleId,
        _ruleController.text,
        _descriptionController.text,
        currentAdminOwnerName!, // Pass the current admin's owner name
      );

      _ruleController.clear();
      _descriptionController.clear();
      Navigator.of(context).pop();
      _fetchRules(); // Refresh the list after editing a rule
    }
  }

  // Delete rule using DatabaseService
  Future<void> _deleteRule(int index) async {
    String ruleId = rules[index]['rule_id']!;
    await _databaseService.deleteRule(ruleId);
    _fetchRules(); // Refresh the list after deleting a rule
  }

  // Show dialog to add or edit rule
  void _showRuleDialog({bool isEdit = false, int? index}) {
    if (isEdit && index != null) {
      _ruleController.text = rules[index]['title']!;
      _descriptionController.text = rules[index]['description']!;
    } else {
      _ruleController.clear();
      _descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Rule" : "Add New Rule"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _ruleController,
                decoration: const InputDecoration(hintText: "Enter rule title"),
              ),
              TextField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(hintText: "Enter rule description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (isEdit && index != null) {
                  _editRule(index);
                } else {
                  _addRule();
                }
              },
              child: Text(isEdit ? "Save" : "Add"),
            ),
            TextButton(
              onPressed: () {
                _ruleController.clear();
                _descriptionController.clear();
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rules and Regulations',
          style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: 60.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showRuleDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD8AFCC),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02, // 2% of screen height
                        horizontal: screenWidth * 0.05, // 5% of screen width
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Rules and Regulation',
                          style: TextStyle(
                            fontSize: getResponsiveFontSize(
                                screenWidth, 0.045), // Responsive font size
                            color: const Color(0xFF66123A),
                          ),
                        ),
                        Icon(
                          Icons.add,
                          size: screenWidth * 0.06, // Responsive icon size
                          color: const Color(0xFF66123A),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                Expanded(
                  child: ListView.builder(
                    itemCount: rules.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              screenWidth * 0.03), // 3% of screen width
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${rules[index]['title']}",
                                style: TextStyle(
                                  fontSize: getResponsiveFontSize(screenWidth,
                                      0.047), // Responsive font size
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                  height: screenHeight *
                                      0.006), // 0.6% of screen height
                              Text(
                                "${rules[index]['description']}",
                                style: TextStyle(
                                  fontSize: getResponsiveFontSize(screenWidth,
                                      0.039), // Responsive font size
                                  color: const Color.fromARGB(255, 71, 70, 70),
                                ),
                              ),
                              SizedBox(
                                  height: screenHeight *
                                      0.006), // 0.6% of screen height
                              Text(
                                "Added by: ${rules[index]['addedBy']}",
                                style: TextStyle(
                                  fontSize: getResponsiveFontSize(screenWidth,
                                      0.035), // Responsive font size
                                  color: const Color.fromARGB(255, 71, 70, 70),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _showRuleDialog(
                                        isEdit: true, index: index),
                                    icon: Icon(
                                      Icons.edit,
                                      color: const Color(0xFF994562),
                                      size: screenWidth * 0.045,
                                    ),
                                    label: Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: getResponsiveFontSize(
                                            screenWidth, 0.038),
                                        color: const Color(0xFF994562),
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => _deleteRule(index),
                                    icon: Icon(
                                      Icons.delete,
                                      color: const Color(0xFF994562),
                                      size: screenWidth * 0.045,
                                    ),
                                    label: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: getResponsiveFontSize(
                                            screenWidth, 0.038),
                                        color: const Color(0xFF994562),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
