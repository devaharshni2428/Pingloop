import 'package:flutter/material.dart';
import 'app_data.dart';
import 'absentee_screen.dart';
import 'department_screen.dart';
import 'login_screen.dart';

class PrincipalDashboardScreen extends StatelessWidget {
  final RoleScope scope;

  const PrincipalDashboardScreen({
    super.key,
    required this.scope,
  });

  @override
  Widget build(BuildContext context) {
    final students = AppData.allStudents();

    final absent = AppData.recentAttendance.fold<int>(
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
        title: const Text('Principal Dashboard'),
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
              'Principal Dashboard',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color(0xFF164A4A),
              ),
            ),
            const Text(
              'Complete college attendance overview',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 22),

            Row(
              children: [
                _stat('Students', '${students.length}'),
                const SizedBox(width: 10),
                _stat('Present', '$present'),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                _stat('Absent', '$absent'),
                const SizedBox(width: 10),
                _stat(
                  'Departments',
                  '${AppData.departments.length}',
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'All Departments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF164A4A),
              ),
            ),

            const SizedBox(height: 10),

            ...AppData.departments.map(
              (department) => _departmentCard(
                context,
                department,
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
                      builder: (_) => const AbsenteeScreen(
                        title: 'College Absentees',
                        department: 'All Departments',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.person_off_outlined,
                ),
                label: const Text(
                  'View All Absent Students',
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

  Widget _departmentCard(
    BuildContext context,
    String department,
  ) {
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

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
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
            fontSize: 16,
            color: Color(0xFF164A4A),
          ),
        ),
        subtitle: Text(
          '${AppData.departmentNames[department]}\n'
          'Present $present  •  Absent $absent',
        ),
        isThreeLine: true,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 17,
          color: Color(0xFF164A4A),
        ),
        onTap: () {
          final detailScope = RoleScope(
            role: 'Principal',
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DepartmentScreen(
                scope: detailScope,
                viewOnly: true,
                initialDepartment: department,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _stat(
    String title,
    String value,
  ) {
    return Expanded(
      child: Container(
        height: 92,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF164A4A),
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