import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  _RulesPageState createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  final DatabaseReference _rulesRef = FirebaseDatabase.instance.ref('rules');
  List<Rule> rulesList = [];

  @override
  void initState() {
    super.initState();
    _fetchRules();
  }

  Future<void> _fetchRules() async {
    DatabaseEvent event = await _rulesRef.once();
    final rulesData = event.snapshot.value as Map<dynamic, dynamic>?;

    if (rulesData != null) {
      rulesData.forEach((key, value) {
        final rule = Rule(
          description: value['description'] ?? 'No Description',
          addedBy: value['addedBy'] ?? 'Unknown',
        );
        rulesList.add(rule);
      });
      setState(() {}); // Update UI after fetching data
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rules',
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Must follow below rules',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 10),
              for (var rule in rulesList)
                RuleCard(
                  description: rule.description,
                  addedBy: rule.addedBy,
                  screenWidth: screenWidth,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RuleCard extends StatelessWidget {
  final String description;
  final String addedBy;
  final double screenWidth;

  const RuleCard({
    super.key,
    required this.description,
    required this.addedBy,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 245, 247, 248),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Aligns content on either side
              children: [
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 63, 62, 62),
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(width: 10), // Spacing between description and addedBy
                Text(
                  'Added by: $addedBy',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 100, 100, 100),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Rule {
  final String description;
  final String addedBy;

  Rule({required this.description, required this.addedBy});
}
