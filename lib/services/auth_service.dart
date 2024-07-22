import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // Save token to shared preferences
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> register(String name, String email, String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      // Registration successful
      return true;
    } else {
      return false;
    }
  }
}
