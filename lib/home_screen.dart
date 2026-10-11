
import 'package:flutter/material.dart';
import 'app_data.dart';
import 'services/student_service.dart';
import 'services/attendance_service.dart';
import 'absentee_screen.dart';
import 'attendance_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final RoleScope scope;

  const HomeScreen({super.key, required this.scope});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> students = [];
  List<dynamic> attendanceRecords = [];

  bool isLoading = true;
  String? errorMessage;

  String get department => widget.scope.department ?? 'CSE';
  String get year => widget.scope.year ?? '2nd Year';
  String get section => widget.scope.section ?? 'B';

  int get yearNumber {
    switch (year) {
      case '1st Year':
        return 1;
      case '2nd Year':
        return 2;
      case '3rd Year':
        return 3;
      case '4th Year':
        return 4;
      default:
        return int.tryParse(year) ?? 2;
    }
  }

  String get today {
    final now = DateTime.now();
    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  int get presentCount => attendanceRecords.where((record) {
        return record['status'].toString().toUpperCase() == 'PRESENT';
      }).length;

  int get absentCount => attendanceRecords.where((record) {
        return record['status'].toString().toUpperCase() == 'ABSENT';
      }).length;

  int get attendancePercentage {
    final marked = presentCount + absentCount;
    return marked == 0 ? 0 : (presentCount * 100 / marked).round();
  }

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final loadedStudents = await StudentService.getStudents(
        department,
        yearNumber,
        section,
      );

      final allAttendance = await AttendanceService.getAttendance(
        date: today,
      );

      final studentIds = loadedStudents
          .map((student) => int.tryParse(
                student['student_id'].toString(),
              ))
          .whereType<int>()
          .toSet();

      // Keep only records belonging to this selected class.
      // If duplicate records exist for a student, keep the latest one.
      final Map<int, dynamic> recordsByStudent = {};

      for (final record in allAttendance) {
        final studentId = int.tryParse(
          record['student_id'].toString(),
        );

        if (studentId != null && studentIds.contains(studentId)) {
          recordsByStudent[studentId] = record;
        }
      }

      if (!mounted) return;

      setState(() {
        students = loadedStudents;
        attendanceRecords = recordsByStudent.values.toList();
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: const Text(
          'PINGLOOP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh dashboard',
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboard,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, Staff 👋',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF164A4A),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${AppData.departmentNames[department] ?? department}'
                ' • $year • Section $section',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 25),

              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Could not load dashboard data.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: _loadDashboard,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: _card(
                        Icons.people_outline,
                        'Students',
                        '${students.length}',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _card(
                        Icons.check_circle_outline,
                        'Present',
                        '$presentCount',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _card(
                        Icons.cancel_outlined,
                        'Absent',
                        '$absentCount',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _card(
                        Icons.percent,
                        'Attendance',
                        '$attendancePercentage%',
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 28),
              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF164A4A),
                ),
              ),
              const SizedBox(height: 12),

              _button(
                context,
                Icons.fact_check_outlined,
                'Mark Attendance',
                AttendanceScreen(
                  department: department,
                  year: year,
                  section: section,
                  staffId: widget.scope.userId,
                ),
              ),
              const SizedBox(height: 10),
              _button(
                context,
                Icons.person_off_outlined,
                'View Absent',
                AbsenteeScreen(
                  title: 'Absent Students',
                  department: department,
                  year: year,
                  section: section,
                ),
              ),

              const SizedBox(height: 28),
              const Text(
                'Today\'s Attendance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF164A4A),
                ),
              ),
              const SizedBox(height: 12),
              if (!isLoading && errorMessage == null)
                _recentSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            today,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF164A4A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            attendanceRecords.isEmpty
                ? 'No attendance marked for this class today.'
                : '$presentCount Present • $absentCount Absent',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '${students.length - attendanceRecords.length} student(s) '
            'not yet marked',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _card(IconData icon, String title, String value) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF164A4A),
            size: 28,
          ),
          const Spacer(),
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
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _button(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );

          if (mounted) {
            _loadDashboard();
          }
        },
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF164A4A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
