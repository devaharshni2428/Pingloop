import 'package:flutter/material.dart';
import 'app_data.dart';
import 'department_screen.dart';
import 'absentee_screen.dart';
import 'attendance_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final RoleScope scope;
  const HomeScreen({super.key, required this.scope});

  @override
  Widget build(BuildContext context) {
    final department = scope.department ?? 'CSE';
    final year = scope.year ?? '2nd Year';
    final section = scope.section ?? 'B';
    final students = AppData.studentsFor(department, year, section);
    final latest = AppData.recentAttendance.where((a) =>
        a['department'] == department && a['year'] == year && a['section'] == section);
    final latestRecord = latest.isNotEmpty ? latest.first : null;
    final present = latestRecord?['presentCount'] as int? ?? students.length;
    final absent = latestRecord?['absentCount'] as int? ?? 0;
    final attendance = students.isEmpty ? 0 : ((present / students.length) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: const Text('PINGLOOP', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Home',
            icon: const Icon(Icons.home_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Welcome, Staff 👋', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF164A4A))),
          const SizedBox(height: 5),
          Text('${AppData.departmentNames[department]} • $year • Section $section', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 25),
          Row(children: [
            Expanded(child: _card(Icons.people_outline, 'Students', '${students.length}')),
            const SizedBox(width: 15),
            Expanded(child: _card(Icons.check_circle_outline, 'Present', '$present')),
          ]),
          const SizedBox(height: 15),
          Row(children: [
            Expanded(child: _card(Icons.cancel_outlined, 'Absent', '$absent')),
            const SizedBox(width: 15),
            Expanded(child: _card(Icons.percent, 'Attendance', '$attendance%')),
          ]),
          const SizedBox(height: 28),
          const Text('Quick Access', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF164A4A))),
          const SizedBox(height: 12),
          _button(context, Icons.fact_check_outlined, 'Mark Attendance', AttendanceScreen(department: department, year: year, section: section)),
          const SizedBox(height: 10),
          _button(context, Icons.person_off_outlined, 'View Absent', AbsenteeScreen(title: 'Absent Students', department: department, year: year, section: section)),
          const SizedBox(height: 25),
          const Text('Recent Marked Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF164A4A))),
          const SizedBox(height: 12),
          if (AppData.recentAttendance.isEmpty)
            _emptyRecent()
          else
            ...AppData.recentAttendance.take(10).map((record) => _recentCard(record)),
        ]),
      ),
    );
  }

  Widget _card(IconData icon, String title, String value) => Container(
    height: 125, padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: const Color(0xFF164A4A), size: 28), const Spacer(),
      Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF164A4A))),
      Text(title, style: const TextStyle(color: Colors.grey)),
    ]),
  );

  Widget _button(BuildContext context, IconData icon, String title, Widget page) => SizedBox(
    width: double.infinity, height: 56,
    child: ElevatedButton.icon(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      icon: Icon(icon), label: Text(title),
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF164A4A), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
    ),
  );

  Widget _recentCard(Map<String, dynamic> record) => Container(
    width: double.infinity, margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
    child: Row(children: [
      const CircleAvatar(backgroundColor: Color(0xFFE8F7F7), child: Icon(Icons.history, color: Color(0xFF164A4A))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${record['department']} • ${record['year']} • Section ${record['section']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF164A4A))),
        const SizedBox(height: 4), Text('${record['presentCount']} Present  •  ${record['absentCount']} Absent', style: const TextStyle(color: Colors.grey)),
      ])),
    ]),
  );

  Widget _emptyRecent() => Container(
    width: double.infinity, padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
    child: const Text('No attendance marked yet.', style: TextStyle(color: Colors.grey)),
  );
}

