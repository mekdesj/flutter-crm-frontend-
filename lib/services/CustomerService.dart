import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';

class CustomerService {
  static const baseUrl =
      'http://localhost:9090/api/customers'; // adjust if needed

  static Future<List<Customer>> getAll(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers: ${response.statusCode}');
    }
  }

  static Future<void> delete(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete customer: ${response.statusCode}');
    }
  }
}
