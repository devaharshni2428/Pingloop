import 'dart:convert';
import 'package:http/http.dart' as http;

class AbsenteeService {
  static const String baseUrl = 'http://localhost:8080';

  static Future<List<dynamic>> getAbsentees() async {
    final today = DateTime.now();

    final date =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    final url = Uri.parse(
      '$baseUrl/api/absentees?date=$date',
    );

    print('ABSENTEE API URL: $url');

    final response = await http.get(url);

    print('ABSENTEE STATUS: ${response.statusCode}');
    print('ABSENTEE BODY: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load absentees: ${response.statusCode}',
      );
    }
  }
}