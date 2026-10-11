import 'package:flutter/material.dart';
import 'app_data.dart';
import 'absentee_screen.dart';

class PrincipalDashboardScreen extends StatelessWidget {
  final RoleScope scope;

  const PrincipalDashboardScreen({
    super.key,
    required this.scope,
  });

  @override
  Widget build(BuildContext context) {
    return const AbsenteeScreen(
      title: 'Principal Absentee Report',
      department: 'All Departments',
    );
  }
}