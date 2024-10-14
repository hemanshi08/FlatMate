// lib/utils/session_manager.dart

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyAdminId = 'admin_id';
  static const String _keyUserId = 'user_id';
  static const String _keyLoginTimestamp = 'login_timestamp';

  // Save admin ID and login timestamp
  static Future<void> saveAdminSession(String adminId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAdminId, adminId);
    await prefs.setInt(_keyLoginTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  // Save user ID
  static Future<void> saveUserSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  // Retrieve admin ID
  static Future<String?> getAdminId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAdminId);
  }

  // Retrieve user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  // Check if the admin session is still valid
  static Future<bool> isAdminSessionValid(int validDurationInMinutes) async {
    final prefs = await SharedPreferences.getInstance();
    final loginTimestamp = prefs.getInt(_keyLoginTimestamp) ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    // Check if the session is still within the valid period
    return (currentTime - loginTimestamp) <= validDurationInMinutes * 60 * 1000;
  }

  // Clear session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
