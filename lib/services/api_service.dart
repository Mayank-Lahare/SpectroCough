// ============================================================
// API Service
// ------------------------------------------------------------
// Responsibilities:
// - Authentication (login / register / logout)
// - JWT storage & validation
// - Fetch current user profile
// - Send audio for prediction
// - Fetch & clear prediction history
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  // ============================================================
  // LOGIN
  // ============================================================

  static Future<bool> login(String email, String password) async {
    final uri = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
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
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    return response.statusCode == 200;
  }

  // ============================================================
  // CHECK LOGIN STATE (with expiry validation)
  // ============================================================

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token == null) return false;

    // Check token expiration
    if (JwtDecoder.isExpired(token)) {
      await prefs.remove("access_token");
      return false;
    }

    return true;
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
  }

  // ============================================================
  // GET CURRENT USER (Protected)
  // Calls /auth/me
  // ============================================================

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final uri = Uri.parse("$baseUrl/auth/me");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token == null) return null;

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

    // If unauthorized, auto logout
    if (response.statusCode == 401) {
      await logout();
    }

    return null;
  }

  // ============================================================
  // ANALYZE AUDIO (Protected)
  // ============================================================

  static Future<Map<String, dynamic>> analyzeAudio(
      File audioFile, {
        required String audioType,
      }) async {
    final uri = Uri.parse("$baseUrl/predict");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    final request = http.MultipartRequest("POST", uri);

    if (token != null) {
      request.headers["Authorization"] = "Bearer $token";
    }

    request.files.add(
      await http.MultipartFile.fromPath("file", audioFile.path),
    );

    request.fields["audio_type"] = audioType;

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody =
      await response.stream.bytesToString();
      return jsonDecode(responseBody);
    }

    if (response.statusCode == 401) {
      await logout();
      throw Exception("Session expired. Please login again.");
    }

    throw Exception("Failed to analyze audio");
  }

  // ============================================================
  // FETCH PREDICTIONS (Protected)
  // ============================================================

  static Future<List<dynamic>> fetchPredictions() async {
    final uri = Uri.parse("$baseUrl/predictions");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token == null) {
      throw Exception("Not authenticated");
    }

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

    if (response.statusCode == 401) {
      await logout();
      throw Exception("Session expired. Please login again.");
    }

    throw Exception("Failed to fetch predictions");
  }

  // ============================================================
  // CLEAR PREDICTIONS (Protected)
  // ============================================================

  static Future<bool> clearPredictions() async {
    final uri = Uri.parse("$baseUrl/predictions");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token == null) return false;

    final response = await http.delete(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      await logout();
      return false;
    }

    return response.statusCode == 200;
  }
}