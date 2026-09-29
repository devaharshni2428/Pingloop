import 'package:flutter/material.dart';
import 'attendance_screen.dart';

class SectionScreen extends StatelessWidget {
  final String department;
  final String year;

  const SectionScreen({
    super.key,
    required this.department,
    required this.year,
  });

  void openAttendance(BuildContext context, String section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceScreen(
          department: department,
          year: year,
          section: section,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const charcoal = Color(0xFF102A2E);
    const teal = Color(0xFF14B8A6);
    const lightTeal = Color(0xFFE6FFFB);

    // Same PINGLOOP background
    const background = Color(0xFFEAF7F5);

    final sections = [
      ['Section A', 'A'],
      ['Section B', 'B'],
      ['Section C', 'C'],
      ['Section D', 'D'],
    ];

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text(
          '$department - $year',
          style: const TextStyle(
            color: charcoal,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: charcoal,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),

            const Text(
              'Select Section',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: charcoal,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Choose a section in $department',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF607477),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: ListView.separated(
                itemCount: sections.length,

                separatorBuilder: (context, index) {
                  return const SizedBox(height: 13);
                },

                itemBuilder: (context, index) {
                  final sectionName = sections[index][0];
                  final section = sections[index][1];

                  return SizedBox(
                    height: 58,

                    child: ElevatedButton(
                      onPressed: () {
                        openAttendance(context, section);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: charcoal,
                        elevation: 1,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                      ),

                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,

                            decoration: BoxDecoration(
                              color: lightTeal,
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Center(
                              child: Text(
                                section,
                                style: const TextStyle(
                                  color: teal,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          Text(
                            sectionName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const Spacer(),

                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: teal,
                          ),
                        ],
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