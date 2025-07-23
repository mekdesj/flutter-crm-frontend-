import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'http://localhost:9090'; // adjust if needed

  static Future<Map<String, dynamic>?> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print('API Response Status: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Decoded API data: $data');
      return {'token': data['token']};
    }

    print('Login failed with status: ${response.statusCode}');
    return null;
  }
}
