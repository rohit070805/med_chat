import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://zonal-courtesy-testing.up.railway.app';
  static const String endpoint = '/chat';
  static const String appSecretKey = 'supersecret123';

  // Make the request
  static Future<String> sendChatRequest(
      String sessionId, String message, List<Map<String, String>> history) async {

    final Uri url = Uri.parse('$baseUrl$endpoint');

    final Map<String, dynamic> body = {
      'sessionId': sessionId,
      'history': history,
      'message': message,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-app-key': appSecretKey,
    };

    try {
      final http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['response'] ?? 'Received an empty response.';
      } else if (response.statusCode == 401) {
        return 'Error 401: Unauthorized. Check your x-app-key.';
      } else {
        return 'Failed to load response: HTTP ${response.statusCode}';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }
}