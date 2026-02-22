import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: Replace with your actual backend URL
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, dynamic>> analyzeAudio(File audioFile) async {
    final uri = Uri.parse('$baseUrl/predict');

    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // must match FastAPI parameter name
        audioFile.path,
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to analyze audio');
    }
  }
}
