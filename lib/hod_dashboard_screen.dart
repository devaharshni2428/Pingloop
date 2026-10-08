import 'package:flutter/material.dart';
import 'app_data.dart';
import 'absentee_screen.dart';
import 'department_screen.dart';
import 'login_screen.dart';

class HodDashboardScreen extends StatelessWidget {
  final RoleScope scope;

  const HodDashboardScreen({
    super.key,
    required this.scope,
  });

  @override
  Widget build(BuildContext context) {
    final department = scope.department ?? 'CSE';
    final students =
        AppData.allStudentsForDepartment(department);

    final absent = AppData.recentAttendance
        .where(
          (attendance) =>
              attendance['department'] == department,
        )
        .fold<int>(
          0,
          (sum, attendance) =>
              sum + ((attendance['absentCount'] as int?) ?? 0),
        );

    final present =
        (students.length - absent).clamp(0, students.length);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: const Text('HOD Dashboard'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          },
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'HOD Dashboard',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color(0xFF164A4A),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              AppData.departmentNames[department] ??
                  department,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                _stat('Students', '${students.length}'),
                const SizedBox(width: 10),
                _stat('Present', '$present'),
                const SizedBox(width: 10),
                _stat('Absent', '$absent'),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Department Classes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF164A4A),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F7F7),
                  child: Icon(
                    Icons.school_outlined,
                    color: Color(0xFF164A4A),
                  ),
                ),
                title: Text(
                  department,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF164A4A),
                  ),
                ),
                subtitle: const Text(
                  'View Year → Section → Students',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF164A4A),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DepartmentScreen(
                        scope: scope,
                        viewOnly: true,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AbsenteeScreen(
                        title: '$department Absentees',
                        department: department,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.person_off_outlined,
                ),
                label: const Text(
                  'View Department Absentees',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF164A4A),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(
    String title,
    String value,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF164A4A),
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