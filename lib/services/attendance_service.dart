import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendanceService {
  static const String baseUrl = 'http://localhost:8080';

  static Future<void> saveAttendance({
    required int studentId,
    required int staffId,
    required String date,
    required String status,
  }) async {
    final url = Uri.parse('$baseUrl/api/attendance');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'student_id': studentId,
        'staff_id': staffId,
        'date': date,
        'status': status,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to save attendance: ${response.body}',
      );
    }
  }
}