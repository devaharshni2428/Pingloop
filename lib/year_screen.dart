import 'package:flutter/material.dart';
import 'app_data.dart';
import 'section_screen.dart';

class YearScreen extends StatelessWidget {
  final String department;
  final RoleScope? scope;
  final bool viewOnly;

  const YearScreen({
    super.key,
    required this.department,
    this.scope,
    this.viewOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    List<String> years;

    if (scope?.role == 'Staff' && scope?.year != null) {
      years = [scope!.year!];
    } else {
      years = const [
        '1st Year',
        '2nd Year',
        '3rd Year',
        '4th Year',
      ];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: Text('$department • Year'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: SizedBox(
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SectionScreen(
                        department: department,
                        year: year,
                        scope: scope,
                        viewOnly: viewOnly,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF164A4A),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                    ),
                    const SizedBox(width: 18),
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}