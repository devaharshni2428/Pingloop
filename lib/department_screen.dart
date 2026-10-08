import 'package:flutter/material.dart';
import 'app_data.dart';
import 'year_screen.dart';

class DepartmentScreen extends StatelessWidget {
  final RoleScope? scope;
  final bool viewOnly;
  final String? initialDepartment;

  const DepartmentScreen({
    super.key,
    this.scope,
    this.viewOnly = false,
    this.initialDepartment,
  });

  @override
  Widget build(BuildContext context) {
    List<String> departments;

    if (initialDepartment != null) {
      departments = [initialDepartment!];
    } else if (scope?.role == 'HOD' ||
        scope?.role == 'Staff') {
      departments = scope?.department != null
          ? [scope!.department!]
          : AppData.departments;
    } else {
      departments = AppData.departments;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: const Text('Select Department'),
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
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final department = departments[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: SizedBox(
              height: 78,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => YearScreen(
                        department: department,
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
                    const Icon(Icons.school_outlined),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            department,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppData.departmentNames[
                                    department] ??
                                '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
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