import 'package:flutter/material.dart';
import 'year_screen.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  void openYearScreen(BuildContext context, String department) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YearScreen(
          department: department,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const charcoal = Color(0xFF102A2E);
    const teal = Color(0xFF14B8A6);
    const lightTeal = Color(0xFFE6FFFB);

    // PINGLOOP logo-style background
    const background = Color(0xFFEAF7F5);

    final departments = [
      ['AIDS', Icons.auto_awesome],
      ['CSE', Icons.computer_outlined],
      ['ECE', Icons.memory_outlined],
      ['EEE', Icons.bolt_outlined],
      ['IT', Icons.devices_outlined],
      ['MECH', Icons.settings_outlined],
      ['MTS', Icons.precision_manufacturing_outlined],
    ];

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'PINGLOOP',
          style: TextStyle(
            color: charcoal,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
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
              'Select Department',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: charcoal,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Choose your department to continue',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF607477),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: ListView.separated(
                itemCount: departments.length,

                separatorBuilder: (context, index) =>
                    const SizedBox(height: 13),

                itemBuilder: (context, index) {
                  final department =
                      departments[index][0] as String;

                  final icon =
                      departments[index][1] as IconData;

                  return SizedBox(
                    height: 58,

                    child: ElevatedButton(
                      onPressed: () {
                        openYearScreen(
                          context,
                          department,
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: charcoal,
                        elevation: 1,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),

                        padding:
                            const EdgeInsets.symmetric(
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
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),

                            child: Icon(
                              icon,
                              color: teal,
                              size: 21,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Text(
                            department,
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