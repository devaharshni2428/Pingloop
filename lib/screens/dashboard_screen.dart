import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'department_screen.dart';
import 'absentee_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false,
            );
          },
        ),

        title: const Text(
          'PINGLOOP',
          style: TextStyle(
            color: charcoal,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
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
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 20),

            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: charcoal,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Today’s attendance overview',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF607477),
              ),
            ),

            const SizedBox(height: 25),

            // Overall Attendance
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: charcoal,
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Overall Attendance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    '80%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'Attendance recorded successfully',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Total + Present
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.people_outline,
                    title: 'Total',
                    value: '50',
                    color: lightTeal,
                    iconColor: teal,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _statCard(
                    icon: Icons.check_circle_outline,
                    title: 'Present',
                    value: '40',
                    color: lightTeal,
                    iconColor: teal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Absent + Today
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.cancel_outlined,
                    title: 'Absent',
                    value: '10',
                    color: lightTeal,
                    iconColor: teal,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _statCard(
                    icon: Icons.calendar_today_outlined,
                    title: 'Today',
                    value: '18 Sep',
                    color: lightTeal,
                    iconColor: teal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Recent Attendance
            const Text(
              'Recent Attendance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: charcoal,
              ),
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,

                    decoration: BoxDecoration(
                      color: lightTeal,
                      borderRadius: BorderRadius.circular(13),
                    ),

                    child: const Icon(
                      Icons.groups_outlined,
                      color: teal,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          'CSE • 3rd Year • Section A',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: charcoal,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Today • 40 Present • 10 Absent',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF607477),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.check_circle,
                    color: teal,
                    size: 23,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: charcoal,
              ),
            ),

            const SizedBox(height: 14),

            // Mark Attendance
            _actionButton(
              icon: Icons.how_to_reg_outlined,
              title: 'Mark Attendance',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const DepartmentScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // View Absentees
            _actionButton(
              icon: Icons.person_off_outlined,
              title: 'View Absentees',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AbsenteeScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  static Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(11),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF607477),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF102A2E),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _actionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 58,

      child: ElevatedButton(
        onPressed: onTap,

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF102A2E),
          elevation: 1,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        child: Row(
          children: [
            const SizedBox(width: 4),

            Icon(
              icon,
              color: const Color(0xFF14B8A6),
            ),

            const SizedBox(width: 14),

            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Color(0xFF14B8A6),
            ),
          ],
        ),
      ),
    );
  }
}