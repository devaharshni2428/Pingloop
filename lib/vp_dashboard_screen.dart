import 'package:flutter/material.dart';
import 'app_data.dart';
import 'absentee_screen.dart';

class VpDashboardScreen extends StatelessWidget {
  final RoleScope scope;

  const VpDashboardScreen({
    super.key,
    required this.scope,
  });

  @override
  Widget build(BuildContext context) {
    return const AbsenteeScreen(
      title: 'Vice Principal Absentee Report',
      department: 'All Departments',
    );
  }
}