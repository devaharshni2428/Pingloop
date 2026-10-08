import 'package:flutter/material.dart';
import 'app_data.dart';
import 'attendance_screen.dart';

class SectionScreen extends StatelessWidget {
  final String department;
  final String year;
  final RoleScope? scope;
  final bool viewOnly;

  const SectionScreen({
    super.key,
    required this.department,
    required this.year,
    this.scope,
    this.viewOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    List<String> sections;

    if (scope?.role == 'Staff' &&
        scope?.section != null) {
      sections = [scope!.section!];
    } else {
      sections = const [
        'A',
        'B',
        'C',
        'D',
      ];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: const Text('Select Section'),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: SizedBox(
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                  if (viewOnly) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SectionStudentsScreen(
                          department: department,
                          year: year,
                          section: section,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AttendanceScreen(
                          department: department,
                          year: year,
                          section: section,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF164A4A),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.groups_outlined),
                    const SizedBox(width: 18),
                    Text(
                      'Section $section',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SectionStudentsScreen extends StatelessWidget {
  final String department;
  final String year;
  final String section;

  const SectionStudentsScreen({
    super.key,
    required this.department,
    required this.year,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final students = AppData.studentsFor(
      department,
      year,
      section,
    );

    final latest = AppData.recentAttendance.where(
      (attendance) =>
          attendance['department'] == department &&
          attendance['year'] == year &&
          attendance['section'] == section,
    );

    final latestAttendance =
        latest.isNotEmpty ? latest.first : null;

    final present = latestAttendance?['presentCount'] as int? ??
        students.length;

    final absent =
        latestAttendance?['absentCount'] as int? ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: Text('Section $section'),
        centerTitle: true,
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
            padding: const EdgeInsets.fromLTRB(
              18,
              18,
              18,
              10,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  department,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF164A4A),
                  ),
                ),
                Text(
                  AppData.departmentNames[department] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$year • Section $section',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _stat(
                      'Students',
                      students.length,
                      const Color(0xFF164A4A),
                    ),
                    const SizedBox(width: 8),
                    _stat(
                      'Present',
                      present,
                      Colors.green,
                    ),
                    const SizedBox(width: 8),
                    _stat(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 18),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];

                final isAbsent =
                    _isAbsent(student, latestAttendance);

                return Card(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.only(bottom: 9),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isAbsent
                          ? const Color(0xFFFFE5E5)
                          : const Color(0xFFE8F7F7),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isAbsent
                              ? Colors.red
                              : const Color(0xFF164A4A),
                        ),
                      ),
                    ),
                    title: Text(
                      student['name'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${student['roll']} • '
                      '${student['year']} • '
                      'Section ${student['section']}',
                    ),
                    trailing: Text(
                      isAbsent ? 'Absent' : 'Present',
                      style: TextStyle(
                        color: isAbsent
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isAbsent(
    Map<String, String> student,
    Map<String, dynamic>? attendance,
  ) {
    if (attendance == null) {
      return false;
    }

    final absentees =
        attendance['absentees'] as List<dynamic>? ?? [];

    return absentees.any(
      (absentStudent) =>
          absentStudent['roll'] == student['roll'],
    );
  }

  Widget _stat(
    String title,
    int value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}