import 'package:flutter/material.dart';
import 'app_data.dart';

class DepartmentDetailScreen extends StatelessWidget {
  final String department;

  const DepartmentDetailScreen({
    super.key,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: Text(department),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            department,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF164A4A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppData.departmentNames[department] ?? '',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Year',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF164A4A),
            ),
          ),
          const SizedBox(height: 10),
          ...AppData.years.map(
            (year) => _yearCard(context, year),
          ),
        ],
      ),
    );
  }

  Widget _yearCard(BuildContext context, String year) {
    final count = AppData.studentsFor(
      department,
      year,
      'A',
    ).length;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F7F7),
          child: Text(
            year[0],
            style: const TextStyle(
              color: Color(0xFF164A4A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          year,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF164A4A),
          ),
        ),
        subtitle: Text('$count students per section'),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Color(0xFF164A4A),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => YearDetailScreen(
                department: department,
                year: year,
              ),
            ),
          );
        },
      ),
    );
  }
}

class YearDetailScreen extends StatelessWidget {
  final String department;
  final String year;

  const YearDetailScreen({
    super.key,
    required this.department,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: Text('$department • $year'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            '$year',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF164A4A),
            ),
          ),
          Text(
            AppData.departmentNames[department] ?? '',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Section',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF164A4A),
            ),
          ),
          const SizedBox(height: 10),
          ...AppData.sections.map(
            (section) => Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE8F7F7),
                  child: Text(
                    section,
                    style: const TextStyle(
                      color: Color(0xFF164A4A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  'Section $section',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF164A4A),
                  ),
                ),
                subtitle: Text(
                  '${AppData.studentsFor(department, year, section).length} students',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Color(0xFF164A4A),
                ),
                onTap: () {
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
                },
              ),
            ),
          ),
        ],
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

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: Text('Section $section'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 15),
                Row(
                  children: [
                    _statBox(
                      'Students',
                      students.length.toString(),
                      const Color(0xFF164A4A),
                    ),
                    const SizedBox(width: 10),
                    _statBox(
                      'Present',
                      _presentCount(students).toString(),
                      Colors.green,
                    ),
                    const SizedBox(width: 10),
                    _statBox(
                      'Absent',
                      _absentCount(students).toString(),
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

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 9),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE8F7F7),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFF164A4A),
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
                      '${student['roll']} • ${student['department']} • ${student['year']} • Section ${student['section']}',
                    ),
                    trailing: _status(student),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _status(Map<String, String> student) {
    for (final attendance in AppData.recentAttendance) {
      if (attendance['department'] == department &&
          attendance['year'] == year &&
          attendance['section'] == section) {
        final absentees =
            attendance['absentees'] as List<dynamic>? ?? [];

        final absent = absentees.any(
          (a) =>
              a['roll'] == student['roll'] ||
              a['name'] == student['name'],
        );

        return Text(
          absent ? 'Absent' : 'Present',
          style: TextStyle(
            color: absent ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    }

    return const Text(
      'Present',
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  int _presentCount(List<Map<String, String>> students) {
    for (final attendance in AppData.recentAttendance) {
      if (attendance['department'] == department &&
          attendance['year'] == year &&
          attendance['section'] == section) {
        return attendance['presentCount'] as int? ?? students.length;
      }
    }
    return students.length;
  }

  int _absentCount(List<Map<String, String>> students) {
    for (final attendance in AppData.recentAttendance) {
      if (attendance['department'] == department &&
          attendance['year'] == year &&
          attendance['section'] == section) {
        return attendance['absentCount'] as int? ?? 0;
      }
    }
    return 0;
  }

  Widget _statBox(
    String title,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}