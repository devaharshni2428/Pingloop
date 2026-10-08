import 'package:flutter/material.dart';
import 'app_data.dart';
import 'absentee_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final String department;
  final String year;
  final String section;

  const AttendanceScreen({
    super.key,
    required this.department,
    required this.year,
    required this.section,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late List<Map<String, dynamic>> students;

  @override
  void initState() {
    super.initState();

    students = AppData.studentsFor(
      widget.department,
      widget.year,
      widget.section,
    ).map((student) {
      return {
        'name': student['name']!,
        'roll': student['roll']!,
        'present': true,
      };
    }).toList();
  }

  void submitAttendance() {
    final absentStudents = students
        .where((student) => student['present'] == false)
        .map((student) => {
              'name': student['name'],
              'roll': student['roll'],
            })
        .toList();

    final presentCount =
        students.where((student) => student['present'] == true).length;

    final absentCount = students.length - presentCount;

    AppData.recentAttendance.insert(0, {
      'department': widget.department,
      'year': widget.year,
      'section': widget.section,
      'presentCount': presentCount,
      'absentCount': absentCount,
      'absentees': absentStudents,
      'time': DateTime.now(),
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Attendance Submitted'),
        content: Text(
          'Present: $presentCount\nAbsent: $absentCount',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              viewAbsent();
            },
            child: const Text('View Absent'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    );
  }

  void viewAbsent() {
    final absentStudents = students
        .where((student) => student['present'] == false)
        .map((student) => {
              'name': student['name'],
              'roll': student['roll'],
            })
        .toList();

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
    final present =
        students.where((student) => student['present'] == true).length;

    final absent = students.length - present;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: const Text('Mark Attendance'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
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
                  AppData.departmentNames[widget.department] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.year} • Section ${widget.section}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _countBox(
                      'Present',
                      present,
                      Colors.green,
                    ),
                    const SizedBox(width: 10),
                    _countBox(
                      'Absent',
                      absent,
                      Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final isPresent = student['present'] == true;

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 9),
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
                      student['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(student['roll']),
                    trailing: Checkbox(
                      value: isPresent,
                      activeColor: const Color(0xFF164A4A),
                      onChanged: (value) {
                        setState(() {
                          student['present'] = value ?? false;
                        });
                      },
                    ),
                    onTap: () {
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
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: viewAbsent,
                    icon: const Icon(Icons.person_off_outlined),
                    label: const Text('View Absent'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF164A4A),
                      side: const BorderSide(
                        color: Color(0xFF164A4A),
                      ),
                      minimumSize: const Size(0, 52),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: submitAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF164A4A),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 52),
                    ),
                    child: const Text('Submit Attendance'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _countBox(
    String title,
    int count,
    Color color,
  ) {
    return Expanded(
      child: Container(
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
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}