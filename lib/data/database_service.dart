import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final DatabaseReference _rulesRef =
      FirebaseDatabase.instance.ref().child('rules');
  final DatabaseReference _adminRef =
      FirebaseDatabase.instance.ref().child('admin');
  final DatabaseReference _residentsRef =
      FirebaseDatabase.instance.ref().child('residents');

  // Function to validate admin credentials
  Future<Map<String, dynamic>?> getAdminCredentials(String username) async {
    try {
      DatabaseEvent event =
          await _adminRef.orderByChild("username").equalTo(username).once();

      if (event.snapshot.exists) {
        final data = event.snapshot.value;
        if (data is Map<dynamic, dynamic> && data.isNotEmpty) {
          return Map<String, dynamic>.from(data.values.first);
        }
      }
      print("No admin found for username: $username");
      return null;
    } catch (e) {
      print("Error fetching admin data: $e");
      return null;
    }
  }

  // Function to validate user credentials
  Future<Map<String, dynamic>?> getUserCredentials(String username) async {
    try {
      DatabaseEvent event = await _database
          .child("residents") // Ensure this matches your Firebase structure
          .orderByChild("username")
          .equalTo(username)
          .once();

      if (event.snapshot.exists) {
        final data = event.snapshot.value;
        if (data is Map<dynamic, dynamic> && data.isNotEmpty) {
          // Assuming each user has a unique username and this returns their data
          return Map<String, dynamic>.from(data.values.first);
        }
      }
      print("No user found for username: $username");
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  // Add a new rule to Firebase without admin name
  Future<void> addRule(String title, String description) async {
    try {
      await _rulesRef.push().set({
        'title': title,
        'description': description,
      });
      print("Rule added successfully: $title");
    } catch (e) {
      print("Error adding rule: $e");
    }
  }

  // Fetch rules without admin names
  Future<List<Map<String, dynamic>>> fetchRules() async {
    List<Map<String, dynamic>> rules = [];

    try {
      DatabaseEvent event = await _rulesRef.once();

      if (event.snapshot.exists) {
        Map<dynamic, dynamic>? rulesData =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (rulesData != null) {
          for (var ruleEntry in rulesData.entries) {
            var rule = ruleEntry.value as Map<dynamic, dynamic>;

            rules.add({
              'rule_id': ruleEntry.key,
              'title': rule['title'],
              'description': rule['description'],
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching rules: $e");
    }

    return rules;
  }

  // Remove 'addedBy' from all existing rules
  Future<void> removeAdminNamesFromRules() async {
    try {
      DatabaseEvent event = await _rulesRef.once();
      if (event.snapshot.exists) {
        Map<dynamic, dynamic>? rulesData =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (rulesData != null) {
          for (var ruleEntry in rulesData.entries) {
            var ruleId = ruleEntry.key;

            await _rulesRef.child(ruleId).child('addedBy').remove();
            print("Removed 'addedBy' from rule ID: $ruleId");
          }
        }
      }
    } catch (e) {
      print("Error removing admin names from rules: $e");
    }
  }

  // Edit an existing rule in Firebase
  Future<void> editRule(String ruleId, String title, String description) async {
    try {
      await _rulesRef.child(ruleId).update({
        "title": title,
        "description": description,
      });
      print("Rule edited successfully: $title");
    } catch (e) {
      print("Error editing rule: $e");
    }
  }

  // Delete a rule from Firebase
  Future<void> deleteRule(String ruleId) async {
    try {
      await _rulesRef.child(ruleId).remove();
      print("Rule deleted successfully: $ruleId");
    } catch (e) {
      print("Error deleting rule: $e");
    }
  }

  // Method to handle logout
  Future<void> logout(BuildContext context, Widget loginScreen) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => loginScreen),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Function to add a new resident with flat_no field
}
