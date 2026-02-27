// ============================================================
// API Service
// ------------------------------------------------------------
// Responsibilities:
// - Send multipart audio file to backend
// - Attach audio type (normal / stethoscopic)
// - Return parsed JSON response
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  // ============================================================
  // Analyze Audio
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

    final request = http.MultipartRequest("POST", uri);

    // Attach file
    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        audioFile.path,
      ),
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
}