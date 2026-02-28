// ============================================================
// API Service
// ------------------------------------------------------------
// Responsibilities:
// - Send multipart audio file to backend
// - Attach audio type (normal / stethoscopic)
// - Handle authentication (login / register)
// - Store and attach JWT token
// - Provide login state & logout
// - Fetch and clear prediction history
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  // ============================================================
  // LOGIN
  // ------------------------------------------------------------
  // Parameters:
  // - email
  // - password
  // ============================================================

  static Future<bool> login(String email, String password) async {
    final uri = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", data["access_token"]);

      return true;
    }

    return false;
  }

  // ============================================================
  // REGISTER
  // ------------------------------------------------------------
  // Parameters:
  // - name
  // - email
  // - password
  // ============================================================

  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    final uri = Uri.parse("$baseUrl/auth/register");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    return response.statusCode == 200;
  }

  // ============================================================
  // Check Login Status
  // ------------------------------------------------------------
  // Returns true if JWT token exists
  // ============================================================

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") != null;
  }

  // ============================================================
  // Logout
  // ------------------------------------------------------------
  // Removes stored JWT token
  // ============================================================

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
  }

  // ============================================================
  // Analyze Audio (Protected)
  // ------------------------------------------------------------
  // Parameters:
  // - audioFile: selected WAV file
  // - audioType: "normal" or "stethoscopic"
  // ============================================================

  static Future<Map<String, dynamic>> analyzeAudio(
    File audioFile, {
    required String audioType,
  }) async {
    final uri = Uri.parse("$baseUrl/predict");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    final request = http.MultipartRequest("POST", uri);

    // Attach JWT token
    if (token != null) {
      request.headers["Authorization"] = "Bearer $token";
    }

    // Attach file
    request.files.add(
      await http.MultipartFile.fromPath("file", audioFile.path),
    );

    // Attach audio type
    request.fields["audio_type"] = audioType;

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      throw Exception("Failed to analyze audio");
    }
  }

  // ============================================================
  // Fetch Predictions (Protected)
  // ------------------------------------------------------------
  // Returns list of prediction history (descending)
  // ============================================================

  static Future<List<dynamic>> fetchPredictions() async {
    final uri = Uri.parse("$baseUrl/predictions");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to fetch predictions");
  }

  // ============================================================
  // Clear Predictions (Protected)
  // ------------------------------------------------------------
  // Deletes all predictions for current user
  // ============================================================

  static Future<bool> clearPredictions() async {
    final uri = Uri.parse("$baseUrl/predictions");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    final response = await http.delete(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return response.statusCode == 200;
  }
}
