import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  final DatabaseReference _adminRef =
      FirebaseDatabase.instance.ref().child('admin');

  final DatabaseReference _rulesRef =
      FirebaseDatabase.instance.ref().child('rules');

  final DatabaseReference _announcementsRef =
      FirebaseDatabase.instance.ref().child('announcements');

  // Function to validate admin credentials
  Future<Map<String, dynamic>?> getAdminCredentials(String username) async {
    try {
      DatabaseEvent event = await _adminRef
          .orderByChild("username")
          .equalTo(username)
          .once(); // Assuming you log in with username

      if (event.snapshot.exists) {
        final data = event.snapshot.value;
        if (data is Map<dynamic, dynamic> && data.isNotEmpty) {
          return Map<String, dynamic>.from(
              data.values.first); // Returns admin data
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
          .child("users")
          .orderByChild("username")
          .equalTo(username)
          .once();

      if (event.snapshot.exists) {
        final data = event.snapshot.value;
        if (data is Map<dynamic, dynamic> && data.isNotEmpty) {
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

  // Method to fetch the owner's name using the admin ID for admin dashboard
  Future<String?> getOwnerNameByAdminId(String adminId) async {
    try {
      DatabaseEvent event =
          await _adminRef.orderByChild("admin_id").equalTo(adminId).once();

      if (event.snapshot.exists) {
        final data = event.snapshot.value;
        if (data is Map<dynamic, dynamic> && data.isNotEmpty) {
          return Map<String, dynamic>.from(
              data.values.first)['ownerName']; // Return the owner's name
        }
      } else {
        print("No owner found for adminId: $adminId");
        return null;
      }
    } catch (e) {
      print("Error fetching owner name: $e");
      return null;
    }
  }

  Future<String?> getCurrentAdminUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('ownerName'); // Fetching from shared preferences
  }

  // Method to get the owner name by admin ID for rulesw screen
  Future<String?> getOwnerNameFromAdminId(String adminId) async {
    try {
      DataSnapshot snapshot = await _adminRef.child(adminId).get();
      if (snapshot.exists) {
        return snapshot.child('ownerName').value as String?;
      }
    } catch (e) {
      print("Error getting owner name: $e");
    }
    return null; // Return null if no owner name is found
  }

  // Add a new rule with the owner's name as "addedBy"
  Future<void> addRule(String title, String description, String addedBy) async {
    try {
      await FirebaseDatabase.instance.ref().child('rules').push().set({
        'title': title,
        'description': description,
        'addedBy': addedBy, // Save the owner name as 'addedBy'
      });
    } catch (e) {
      print("Error adding rule: $e");
    }
  }

  // Fetch rules including the admin names
  Future<List<Map<String, dynamic>>> fetchRules() async {
    List<Map<String, dynamic>> rules = [];
    try {
      DatabaseEvent event = await _rulesRef.once();

      if (event.snapshot.exists) {
        print("Snapshot data: ${event.snapshot.value}");
        Map<dynamic, dynamic>? rulesData =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (rulesData != null) {
          for (var ruleEntry in rulesData.entries) {
            var rule = ruleEntry.value as Map<dynamic, dynamic>;

            rules.add({
              'rule_id': ruleEntry.key,
              'title': rule['title'],
              'description': rule['description'],
              'addedBy': rule['addedBy'],
            });
          }
        }
      } else {
        print("No rules found."); // Handle the case when no rules are present
      }
    } catch (e) {
      print("Error fetching rules: $e");
    }

    return rules;
  }

// Edit rule method with 'addedBy' (owner name)
  Future<void> editRule(
      String ruleId, String title, String description, String addedBy) async {
    await _rulesRef.child(ruleId).update({
      'title': title,
      'description': description,
      'addedBy': addedBy, // Store the admin's owner name
    });
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

  // Public method to generate a new announcement ID
  String? generateAnnouncementId() {
    return _announcementsRef.push().key; // Use the private reference internally
  }

// Fetch announcements for a specific admin
  Future<List<Map<String, String>>> fetchAnnouncements(String adminId) async {
    List<Map<String, String>> announcements = [];

    try {
      // Get the data snapshot from the announcements node
      final DatabaseEvent event = await _announcementsRef.once();
      final DataSnapshot snapshot = event.snapshot;

      // Check if the snapshot has data
      if (snapshot.value != null) {
        // Safely cast the snapshot value
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        // Filter announcements by adminId
        for (var entry in data.entries) {
          final key = entry.key;
          final value = entry.value;

          // Ensure value is a map before accessing its properties
          if (value is Map<dynamic, dynamic>) {
            Map<String, dynamic> announcement =
                Map<String, dynamic>.from(value);

            // Check if admin_id exists and matches adminId
            if (announcement["admin_id"] == adminId) {
              announcements.add({
                "announcement_id": key.toString(), // Ensure key is a string
                ...Map<String, String>.from(
                    announcement), // Convert all values to String
              });
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching announcements: ${e.toString()}");
    }

    return announcements;
  }

// Add a new announcement to the database
  Future<void> addAnnouncement(
      Map<String, String> announcement, String adminId) async {
    try {
      announcement["admin_id"] =
          adminId; // Add the adminId to the announcement data

      // Check if announcement_id exists and is a non-empty string
      if (announcement.containsKey("announcement_id") &&
          announcement["announcement_id"]!.isNotEmpty) {
        await _announcementsRef
            .child(announcement["announcement_id"]!)
            .set(announcement);
      } else {
        throw Exception("Announcement ID is not provided or is empty.");
      }
    } catch (e) {
      print("Error adding announcement: ${e.toString()}");
    }
  }

  // Edit an existing announcement
  Future<void> editAnnouncement(
      String key, Map<String, String> updatedAnnouncement) async {
    await _announcementsRef.child(key).update(updatedAnnouncement);
  }

  // Delete an announcement
  Future<void> deleteAnnouncement(String key) async {
    await _announcementsRef.child(key).remove();
  }

  // Existing method for logging out
  void logout(BuildContext context, Widget loginScreen) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => loginScreen),
    );
  }
}
