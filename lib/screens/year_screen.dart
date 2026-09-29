import 'package:flutter/material.dart';
import 'section_screen.dart';

class YearScreen extends StatelessWidget {
  final String department;

  const YearScreen({
    super.key,
    required this.department,
  });

  void openSectionScreen(BuildContext context, String year) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionScreen(
          department: department,
          year: year,
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

    final years = [
      ['1st Year', Icons.looks_one_outlined],
      ['2nd Year', Icons.looks_two_outlined],
      ['3rd Year', Icons.looks_3_outlined],
      ['4th Year', Icons.looks_4_outlined],
    ];

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text(
          department,
          style: const TextStyle(
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
              'Select Year',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: charcoal,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Choose a year in $department',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF607477),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: ListView.separated(
                itemCount: years.length,

                separatorBuilder: (context, index) =>
                    const SizedBox(height: 13),

                itemBuilder: (context, index) {
                  final year = years[index][0] as String;
                  final icon = years[index][1] as IconData;

                  return SizedBox(
                    height: 58,

                    child: ElevatedButton(
                      onPressed: () {
                        openSectionScreen(
                          context,
                          year,
                        );
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
                            year,
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