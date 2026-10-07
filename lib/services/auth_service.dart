import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:8080';

  static Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {

    final url = Uri.parse('$baseUrl/api/auth/login');

    print('LOGIN URL: $url');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Server error: ${response.statusCode} ${response.body}',
      );
    }
  }
}