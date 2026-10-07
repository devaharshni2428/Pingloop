import 'package:flutter/material.dart';
import 'services/attendance_service.dart';
import 'services/absentee_service.dart';
import 'services/student_service.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const PingLoopApp());
}

class PingLoopApp extends StatelessWidget {
  const PingLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PINGLOOP',
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
  String email = emailController.text.trim();
  String password = passwordController.text;

  try {
   final result = await AuthService.login(email, password);

if (result['success'] == true) {
  final role = result['role'];

  if (role == 'STAFF') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DepartmentScreen(),
      ),
    );
  } else if (role == 'HOD' ||
      role == 'VICE_PRINCIPAL' ||
      role == 'PRINCIPAL') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AbsenteeViewScreen(),
      ),
    );
  }
}
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ?? 'Invalid Email or Password',
          ),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'PINGLOOP',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Connect. Mark. Track',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  String? selectedDepartment;

  final List<String> departments = [
    'AI&DS',
    'CSE',
    'ECE',
    'EEE',
    'IT',
    'MECH',
    'MTS',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Department'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Department',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(),
              ),
              value: selectedDepartment,
              items: departments.map((department) {
                return DropdownMenuItem(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedDepartment == null
    ? null
    : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YearScreen(
              department: selectedDepartment!,
            ),
          ),
        );
      },
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class YearScreen extends StatefulWidget {
  final String department;

  const YearScreen({
    super.key,
    required this.department,
  });

  @override
  State<YearScreen> createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen> {
  String? selectedYear;

  final List<String> years = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Year'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Department: ${widget.department}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Select Year',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(),
              ),
              value: selectedYear,
              items: years.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedYear = value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedYear == null
                    ? null
                    : () {
                        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SectionScreen(
      department: widget.department,
      year: selectedYear!,
    ),
  ),
);
                      },
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SectionScreen extends StatefulWidget {
  final String department;
  final String year;

  const SectionScreen({
    super.key,
    required this.department,
    required this.year,
  });

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  String? selectedSection;

  final List<String> sections = [
    'A',
    'B',
    'C',
    'D',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Section'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Department: ${widget.department}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Year: ${widget.year}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Select Section',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Section',
                border: OutlineInputBorder(),
              ),
              value: selectedSection,
              items: sections.map((section) {
                return DropdownMenuItem(
                  value: section,
                  child: Text('Section $section'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSection = value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedSection == null
    ? null
    : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceScreen(
              department: widget.department,
              year: widget.year,
              section: selectedSection!,
            ),
          ),
        );
      },
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
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
  List<Map<String, dynamic>> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final data = await StudentService.getStudents(
        widget.department,
        int.parse(widget.year.replaceAll(RegExp(r'[^0-9]'), '')),
        widget.section,
);

      setState(() {
        students = data.map<Map<String, dynamic>>((student) {
          return {
            'studentId': student['student_id'],
            'registerNumber': student['register_number'],
            'name': student['student_name'],
            'present': true,
          };
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('FAILED TO LOAD STUDENTS: $e');
    }
  }
Future<void> _submitAttendance() async {
  try {
    final today = DateTime.now();
    final date =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    for (final student in students) {
      await AttendanceService.saveAttendance(
        studentId: student['studentId'],
        staffId: 1,
        date: date,
        status: student['present'] == true ? 'PRESENT' : 'ABSENT',
      );
    }

    final absentStudents =
        students.where((student) => student['present'] == false).toList();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AbsenteeScreen(
          department: widget.department,
          year: widget.year,
          section: widget.section,
          absentStudents: absentStudents,
        ),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to save attendance: $e'),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : students.isEmpty
              ? const Center(
                  child: Text(
                    'No students found',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  children: [

                    // Selected class details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '${widget.department} - Year ${widget.year} - Section ${widget.section}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Student list
                    Expanded(
                      child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {

                          final student = students[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  '${index + 1}',
                                ),
                              ),

                              title: Text(
                                student['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              subtitle: Text(
                                student['registerNumber'],
                              ),

                              trailing: Checkbox(
                                value: student['present'],

                                onChanged: (value) {
                                  setState(() {
                                    student['present'] = value ?? false;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Submit button
                    Padding(
                      padding: const EdgeInsets.all(16),

                      child: SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(
                          onPressed: _submitAttendance,

                          child: const Text(
                            'Submit Attendance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
class AbsenteeScreen extends StatelessWidget {
  final String department;
  final String year;
  final String section;
  final List<Map<String, dynamic>> absentStudents;

  const AbsenteeScreen({
    super.key,
    required this.department,
    required this.year,
    required this.section,
    required this.absentStudents,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absentee List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$department • $year • Section $section',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Total Absentees: ${absentStudents.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: absentStudents.isEmpty
                  ? const Center(
                      child: Text(
                        'No absentees 🎉',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      itemCount: absentStudents.length,
                      itemBuilder: (context, index) {
                        final student = absentStudents[index];

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(student['name']),
                            subtitle: Text(
                              student['registerNumber'],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
class AbsenteeViewScreen extends StatefulWidget {
  const AbsenteeViewScreen({super.key});

  @override
  State<AbsenteeViewScreen> createState() => _AbsenteeViewScreenState();
}

class _AbsenteeViewScreenState extends State<AbsenteeViewScreen> {
  List<dynamic> absentees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAbsentees();
  }

  Future<void> _loadAbsentees() async {
    try {
      final data = await AbsenteeService.getAbsentees();

      if (!mounted) return;

      setState(() {
        absentees = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      print('FAILED TO LOAD ABSENTEES: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absentee List'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : absentees.isEmpty
              ? const Center(
                  child: Text(
                    'No absentees found',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: absentees.length,
                  itemBuilder: (context, index) {
                    final student = absentees[index];

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          student['student_name'] ?? '',
                        ),
                        subtitle: Text(
                          '${student['register_number'] ?? ''}\n'
                          '${student['department'] ?? ''} • '
                          '${student['year'] ?? ''} Year • '
                          'Section ${student['section'] ?? ''}',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}