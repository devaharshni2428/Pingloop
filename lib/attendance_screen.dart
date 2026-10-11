
import 'package:flutter/material.dart';
import 'app_data.dart';
import 'absentee_screen.dart';
import 'services/student_service.dart';
import 'services/attendance_service.dart';

class AttendanceScreen extends StatefulWidget {
  final String department;
  final String year;
  final String section;
  final int? staffId;

  const AttendanceScreen({
    super.key,
    required this.department,
    required this.year,
    required this.section,
    this.staffId,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> students = [];
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  int get numericYear =>
      int.tryParse(widget.year.replaceAll(RegExp(r'[^0-9]'), '')) ?? 2;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    try {
      final result = await StudentService.getStudents(
        widget.department,
        numericYear,
        widget.section,
      );

      final loadedStudents = result.map<Map<String, dynamic>>((item) {
        final student = Map<String, dynamic>.from(item);
        return {
          'id': student['student_id'],
          'name': student['student_name'] ?? 'Unknown Student',
          'roll': student['register_number'] ?? '',
          'present': true,
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        students = loadedStudents;
        isLoading = false;
        errorMessage = loadedStudents.isEmpty
            ? 'No students found for ${widget.department}, Year $numericYear, Section ${widget.section}.'
            : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Could not load students.\n$e';
      });
    }
  }

  String get today {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  int get presentCount =>
      students.where((s) => s['present'] == true).length;

  int get absentCount => students.length - presentCount;

  List<Map<String, dynamic>> get absentStudents => students
      .where((s) => s['present'] == false)
      .map((s) => {
            'name': s['name'],
            'roll': s['roll'],
          })
      .toList();

  Future<void> submitAttendance() async {
    if (students.isEmpty || isSaving) return;

    if (widget.staffId == null || widget.staffId! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Staff ID missing. Please log in again.'),
        ),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      for (final student in students) {
        final studentId = student['id'];

        if (studentId is! num) {
          throw Exception('Invalid student ID for ${student['name']}');
        }

        await AttendanceService.saveAttendance(
          studentId: studentId.toInt(),
          staffId: widget.staffId!,
          date: today,
          status: student['present'] == true ? 'PRESENT' : 'ABSENT',
        );
      }

      if (!mounted) return;

      AppData.recentAttendance.insert(0, {
        'department': widget.department,
        'year': widget.year,
        'section': widget.section,
        'presentCount': presentCount,
        'absentCount': absentCount,
        'absentees': absentStudents,
        'time': DateTime.now(),
      });

      setState(() => isSaving = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Attendance Submitted'),
          content: Text(
            'Saved to database successfully!\n\n'
            'Present: $presentCount\n'
            'Absent: $absentCount',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AbsenteeScreen(
                      title: 'Absent Students',
                      department: widget.department,
                      year: widget.year,
                      section: widget.section,
                      absentees: absentStudents,
                    ),
                  ),
                );
              },
              child: const Text('View Absent'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Dashboard'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save attendance: $e')),
      );
    }
  }

  void viewAbsent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AbsenteeScreen(
          title: 'Absent Students',
          department: widget.department,
          year: widget.year,
          section: widget.section,
          absentees: absentStudents,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: const Text('Mark Attendance'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 44, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              errorMessage = null;
                            });
                            loadStudents();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.department,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF164A4A),
                            ),
                          ),
                          Text(
                            '${widget.year} • Section ${widget.section}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _countBox(
                                  'Present',
                                  presentCount,
                                  Colors.green,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _countBox(
                                  'Absent',
                                  absentCount,
                                  Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          final isPresent = student['present'] == true;

                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isPresent
                                    ? const Color(0xFFE8F7F7)
                                    : const Color(0xFFFFE5E5),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isPresent
                                        ? const Color(0xFF164A4A)
                                        : Colors.red,
                                  ),
                                ),
                              ),
                              title: Text(
                                student['name'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(student['roll'].toString()),
                              trailing: Checkbox(
                                value: isPresent,
                                activeColor: const Color(0xFF164A4A),
                                onChanged: isSaving
                                    ? null
                                    : (value) {
                                        setState(() {
                                          student['present'] = value ?? false;
                                        });
                                      },
                              ),
                              onTap: isSaving
                                  ? null
                                  : () {
                                      setState(() {
                                        student['present'] = !isPresent;
                                      });
                                    },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isSaving ? null : viewAbsent,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 50),
                                foregroundColor: const Color(0xFF164A4A),
                              ),
                              child: const Text('View Absent'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isSaving ? null : submitAttendance,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 50),
                                backgroundColor: const Color(0xFF164A4A),
                                foregroundColor: Colors.white,
                              ),
                              child: isSaving
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Submit Attendance'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _countBox(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
