
import 'dart:convert';
import 'package:http/http.dart' as http;

class AbsenteeService {
  static const String baseUrl = 'http://localhost:8080';

  static Future<List<dynamic>> getAbsentees({
    String? date,
  }) async {
    final selectedDate = date ?? _today();

    final url = Uri.parse(
      '$baseUrl/api/absentees',
    ).replace(
      queryParameters: {'date': selectedDate},
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data;
      }

      throw Exception('Unexpected absentee API response');
    }

    throw Exception(
      'Failed to load absentees: '
      '${response.statusCode} ${response.body}',
    );
  }

  static String _today() {
    final now = DateTime.now();

    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }
}
