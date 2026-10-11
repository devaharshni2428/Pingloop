
import 'package:flutter/material.dart';
import 'app_data.dart';
import 'absentee_screen.dart';

class HodDashboardScreen extends StatelessWidget {
  final RoleScope scope;

  const HodDashboardScreen({
    super.key,
    required this.scope,
  });

  @override
  Widget build(BuildContext context) {
    final department = scope.department ?? 'CSE';

    return AbsenteeScreen(
      title: 'HOD Absentee Report',
      department: department,
    );
  }
}
