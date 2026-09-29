import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

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
  final List<Map<String, dynamic>> students = [
    {
      'name': 'Arun Kumar',
      'registerNumber': '23CSE001',
      'present': true,
    },
    {
      'name': 'Priya',
      'registerNumber': '23CSE002',
      'present': true,
    },
    {
      'name': 'Karthik',
      'registerNumber': '23CSE003',
      'present': true,
    },
    {
      'name': 'Divya',
      'registerNumber': '23CSE004',
      'present': true,
    },
    {
      'name': 'Rahul',
      'registerNumber': '23CSE005',
      'present': true,
    },
  ];

  String getCurrentDate() {
    final now = DateTime.now();

    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  int get presentCount {
    return students
        .where((student) => student['present'] == true)
        .length;
  }

  int get absentCount {
    return students.length - presentCount;
  }

  void markAllPresent() {
    setState(() {
      for (final student in students) {
        student['present'] = true;
      }
    });
  }

  void submitAttendance() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6FFFB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF14B8A6),
                  size: 38,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Attendance Submitted',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102A2E),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                '${widget.department} • ${widget.year}\nSection ${widget.section}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF607477),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6FFFB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$presentCount',
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF14B8A6),
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Present',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF607477),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F6F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$absentCount',
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF102A2E),
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Absent',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF607477),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF102A2E),
                    foregroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'GO TO DASHBOARD',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const charcoal = Color(0xFF102A2E);
    const teal = Color(0xFF14B8A6);
    const lightTeal = Color(0xFFE6FFFB);
    const background = Color(0xFFE8F7F7);

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: charcoal,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Take Attendance',
          style: TextStyle(
            color: charcoal,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            tooltip: 'Home',
            icon: const Icon(
              Icons.home_outlined,
              color: teal,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
                (route) => false,
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 15),

            Text(
              '${widget.department} • ${widget.year} • Section ${widget.section}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: charcoal,
              ),
            ),

            const SizedBox(height: 6),

            // Date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: teal,
                ),
                const SizedBox(width: 7),
                Text(
                  getCurrentDate(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF607477),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Attendance Counter
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: lightTeal,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: teal,
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 9),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Present',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF607477),
                              ),
                            ),
                            Text(
                              '$presentCount',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: charcoal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 1,
                    height: 38,
                    color: const Color(0xFFD5E5E4),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F6F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.cancel_outlined,
                              color: charcoal,
                              size: 20,
                            ),
                          ),

                          const SizedBox(width: 9),

                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Absent',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF607477),
                                ),
                              ),
                              Text(
                                '$absentCount',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: charcoal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Mark All Present
            SizedBox(
              height: 42,
              child: OutlinedButton.icon(
                onPressed: markAllPresent,
                icon: const Icon(
                  Icons.done_all,
                  size: 18,
                  color: teal,
                ),
                label: const Text(
                  'MARK ALL PRESENT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: teal,
                    letterSpacing: 0.6,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: teal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: students.length,

                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    color: Color(0xFFD5E5E4),
                  );
                },

                itemBuilder: (context, index) {
                  final student = students[index];

                  return Container(
                    color: background,

                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),

                      title: Text(
                        student['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: charcoal,
                        ),
                      ),

                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          student['registerNumber'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF718486),
                          ),
                        ),
                      ),

                      trailing: Checkbox(
                        value: student['present'],
                        activeColor: teal,
                        checkColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),

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

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: submitAttendance,

                style: ElevatedButton.styleFrom(
                  backgroundColor: charcoal,
                  foregroundColor: Colors.white,
                  elevation: 2,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: const Text(
                  'SUBMIT ATTENDANCE',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}