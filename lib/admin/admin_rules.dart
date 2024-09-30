import 'package:flutter/material.dart';

class AdminRulesScreen extends StatefulWidget {
  @override
  _AdminRulesScreenState createState() => _AdminRulesScreenState();
}

class _AdminRulesScreenState extends State<AdminRulesScreen> {
  List<Map<String, String>> rules = [
    {
      "title":
          "Residents are responsible for maintaining the cleanliness and condition of their unit.",
    },
    {
      "title":
          "In case of emergencies (e.g., major leaks, electrical issues), contact 1234567890 immediately.",
    },
    {
      "title":
          "Please respect quiet hours from 11PM to 6AM. Excessive noise or disturbances are not permitted.",
    },
    {
      "title":
          "Lock all doors and windows when leaving your unit. Report any security concerns to 9874563210.",
    },
  ];

  final TextEditingController _ruleController = TextEditingController();

  void _addRule() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Rule"),
          content: TextField(
            controller: _ruleController,
            decoration: InputDecoration(hintText: "Enter rule"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_ruleController.text.isNotEmpty) {
                  setState(() {
                    rules.add({"title": _ruleController.text});
                  });
                  _ruleController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text("Add"),
            ),
            TextButton(
              onPressed: () {
                _ruleController.clear();
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _editRule(int index) {
    _ruleController.text = rules[index]["title"]!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Rule"),
          content: TextField(
            controller: _ruleController,
            decoration: InputDecoration(hintText: "Edit rule"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  rules[index]["title"] = _ruleController.text;
                });
                _ruleController.clear();
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () {
                _ruleController.clear();
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rules and Regulations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Full-width button with label on left and icon on right
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addRule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD8AFCC),
                      padding: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.019,
                        horizontal: constraints.maxHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded border
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Rules and Regulation',
                          style: TextStyle(
                            fontSize:
                                constraints.maxWidth * 0.045, // Increased size
                            color: const Color(0xFF66123A), // Label color
                          ),
                        ),
                        // Adds space between label and icon
                        Icon(
                          Icons.add,
                          size: constraints.maxWidth * 0.06, // Increased size
                          color: const Color(0xFF66123A), // Plus sign color
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.02),
                Expanded(
                  child: ListView.builder(
                    itemCount: rules.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded border
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(constraints.maxWidth * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rules[index]["title"]!,
                                style: TextStyle(
                                  fontSize: constraints.maxWidth *
                                      0.04, // Increased size
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.005),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _editRule(index),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: constraints.maxWidth *
                                          0.04, // Adjusted size
                                    ),
                                    label: Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: constraints.maxWidth *
                                            0.035, // Adjusted size
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        rules.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: constraints.maxWidth *
                                          0.04, // Adjusted size
                                    ),
                                    label: Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: constraints.maxWidth *
                                            0.035, // Adjusted size
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
