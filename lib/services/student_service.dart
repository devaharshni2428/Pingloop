import 'dart:convert';
import 'package:http/http.dart' as http;

class StudentService {
  static const String baseUrl = 'http://localhost:8080';

  static Future<List<dynamic>> getStudents(
      String department,
      int year,
      String section,
      ) async {
    final url = Uri.parse(
      '$baseUrl/api/students'
      '?department=$department'
      '&year=$year'
      '&section=$section',
    );
    print('STUDENT API URL: $url');

    final response = await http.get(url);
    print('STUDENT URL: $url');
    print('STUDENT STATUS: ${response.statusCode}');
    print('STUDENT BODY: ${response.body}');

    print('STUDENT API STATUS: ${response.statusCode}');
    print('STUDENT API BODY: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load students');
    }
  }
}