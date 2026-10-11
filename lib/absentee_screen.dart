
import 'package:flutter/material.dart';
import 'app_data.dart';
import 'services/absentee_service.dart';

class AbsenteeScreen extends StatefulWidget {
  final String title;
  final String department;
  final String? year;
  final String? section;
  final List<Map<String, dynamic>>? absentees;

  const AbsenteeScreen({
    super.key,
    required this.title,
    required this.department,
    this.year,
    this.section,
    this.absentees,
  });

  @override
  State<AbsenteeScreen> createState() => _AbsenteeScreenState();
}

class _AbsenteeScreenState extends State<AbsenteeScreen> {
  late DateTime selectedDate;
  late String selectedDepartment;
  late Future<List<Map<String, dynamic>>> absenteeFuture;

  bool get isCollegeWide =>
      widget.department == 'All Departments';

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedDepartment = widget.department;
    _loadRecords();
  }

  String get formattedDate {
    return '${selectedDate.year.toString().padLeft(4, '0')}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')}';
  }

  void _loadRecords() {
    absenteeFuture = _fetchRecords();
  }

  Future<List<Map<String, dynamic>>> _fetchRecords() async {
    if (widget.absentees != null) {
      return widget.absentees!;
    }

    final response = await AbsenteeService.getAbsentees(
      date: formattedDate,
    );

    return response.map<Map<String, dynamic>>((item) {
      final student = Map<String, dynamic>.from(item as Map);

      return {
        'student_id': student['student_id'],
        'name': student['student_name'] ?? '',
        'roll': student['register_number'] ?? '',
        'department': student['department'] ?? '',
        'year': student['year']?.toString() ?? '',
        'section': student['section']?.toString() ?? '',
        'date': student['date'] ?? formattedDate,
      };
    }).where((student) {
      final departmentMatches =
          selectedDepartment == 'All Departments' ||
          student['department'].toString().toUpperCase() ==
              selectedDepartment.toUpperCase();

      final yearMatches = widget.year == null ||
          student['year'].toString() ==
              widget.year!.replaceAll(RegExp(r'[^0-9]'), '');

      final sectionMatches = widget.section == null ||
          student['section'].toString().toUpperCase() ==
              widget.section!.toUpperCase();

      return departmentMatches && yearMatches && sectionMatches;
    }).toList();
  }

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select attendance date',
    );

    if (picked == null || !mounted) return;

    setState(() {
      selectedDate = picked;
      _loadRecords();
    });
  }

  void _chooseDepartment(String? department) {
    if (department == null) return;

    setState(() {
      selectedDepartment = department;
      _loadRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final departments = <String>{
      'All Departments',
      ...AppData.departments.map((d) => d.toString()),
    }.toList();

    if (!departments.contains(selectedDepartment)) {
      departments.add(selectedDepartment);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164A4A),
        foregroundColor: Colors.white,
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Home',
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Absentee Report',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF164A4A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // HOD stays within their department.
                  // VP and Principal can filter college-wide records.
                  if (isCollegeWide) ...[
                    const Text(
                      'Department',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedDepartment,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      items: departments.map((department) {
                        return DropdownMenuItem<String>(
                          value: department,
                          child: Text(
                            department == 'All Departments'
                                ? department
                                : AppData.departmentNames[department] ??
                                    department,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: _chooseDepartment,
                    ),
                    const SizedBox(height: 12),
                  ] else
                    Text(
                      AppData.departmentNames[widget.department] ??
                          widget.department,
                      style: const TextStyle(color: Colors.grey),
                    ),

                  OutlinedButton.icon(
                    onPressed: _chooseDate,
                    icon: const Icon(Icons.calendar_month),
                    label: Text('Attendance date: $formattedDate'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: absenteeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF164A4A),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            size: 42,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Could not load absentee records.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(_loadRecords);
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final records = snapshot.data ??
                      <Map<String, dynamic>>[];

                  if (records.isEmpty) {
                    return const Center(
                      child: Text(
                        'No absentees found for this date.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF164A4A),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${records.length} absent student(s)',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final student = records[index];

                            final details = [
                              student['roll']?.toString() ?? '',
                              student['department']?.toString() ?? '',
                              if ((student['year'] ?? '')
                                  .toString()
                                  .isNotEmpty)
                                'Year ${student['year']}',
                              if ((student['section'] ?? '')
                                  .toString()
                                  .isNotEmpty)
                                'Section ${student['section']}',
                              student['date']?.toString() ??
                                  formattedDate,
                            ].where((value) => value.isNotEmpty).join(' • ');

                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xFFFFE5E5),
                                  child: Icon(
                                    Icons.person_off_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                                title: Text(
                                  student['name']?.toString() ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(details),
                                trailing: const Text(
                                  'ABSENT',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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