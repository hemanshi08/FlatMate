import 'package:flatmate/data/database_service.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchRules();
  }

  // Helper function for responsive font size
  double getResponsiveFontSize(double screenWidth, double multiplier,
      {double minSize = 10.0}) {
    double calculatedSize = screenWidth * multiplier;
    return calculatedSize < minSize ? minSize : calculatedSize;
  }

  // Fetch rules from Firebase without admin names
  Future<void> _fetchRules() async {
    List<Map<String, dynamic>> fetchedRules =
        await _databaseService.fetchRules();
    setState(() {
      rules = fetchedRules;
    });
  }

  // Add rule through the DatabaseService
  Future<void> _addRule() async {
    if (_ruleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      await _databaseService.addRule(
        _ruleController.text,
        _descriptionController.text,
      );

      _ruleController.clear();
      _descriptionController.clear();
      Navigator.of(context).pop();
      _fetchRules(); // Refresh the list after adding a rule
    }
  }

  // Edit rule using DatabaseService
  Future<void> _editRule(int index) async {
    String ruleId = rules[index]['rule_id']!;
    if (_ruleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      await _databaseService.editRule(
        ruleId,
        _ruleController.text,
        _descriptionController.text,
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
                                      0.005), // 0.5% of screen height
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _showRuleDialog(
                                        isEdit: true, index: index),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: screenWidth *
                                          0.05, // Responsive icon size
                                    ),
                                    label: Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: getResponsiveFontSize(
                                            screenWidth,
                                            0.039), // Responsive font size
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => _deleteRule(index),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: screenWidth *
                                          0.05, // Responsive icon size
                                    ),
                                    label: Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: getResponsiveFontSize(
                                            screenWidth,
                                            0.039), // Responsive font size
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
