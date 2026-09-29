import 'package:flutter/material.dart';

class AbsenteeScreen extends StatelessWidget {
  const AbsenteeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const charcoal = Color(0xFF102A2E);
    const teal = Color(0xFF14B8A6);
    const background = Color(0xFFE8F7F7);

    final absentees = [
      {
        'name': 'Arun Kumar',
        'registerNumber': '23CSE001',
      },
      {
        'name': 'Priya',
        'registerNumber': '23CSE002',
      },
      {
        'name': 'Karthik',
        'registerNumber': '23CSE003',
      },
    ];

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: charcoal,
        ),
        title: const Text(
          'Absentees',
          style: TextStyle(
            color: charcoal,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 20),

            const Text(
              'Absent Students',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: charcoal,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Students marked absent for today',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF607477),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: ListView.separated(
                itemCount: absentees.length,

                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    color: Color(0xFFD5E5E4),
                  );
                },

                itemBuilder: (context, index) {
                  final student = absentees[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),

                    leading: Container(
                      width: 42,
                      height: 42,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: const Icon(
                        Icons.person_outline,
                        color: teal,
                        size: 23,
                      ),
                    ),

                    title: Text(
                      student['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: charcoal,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),

                      child: Text(
                        student['registerNumber']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF718486),
                        ),
                      ),
                    ),

                    trailing: const Icon(
                      Icons.close_rounded,
                      color: teal,
                      size: 22,
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