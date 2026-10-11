class AppData {
  static const List<String> departments = [
    'AIDS',
    'CSE',
    'ECE',
    'EEE',
    'IT',
    'MECH',
    'MTS',
  ];

  static const Map<String, String> departmentNames = {
    'AIDS': 'Artificial Intelligence and Data Science',
    'CSE': 'Computer Science and Engineering',
    'ECE': 'Electronics and Communication Engineering',
    'EEE': 'Electrical and Electronics Engineering',
    'IT': 'Information Technology',
    'MECH': 'Mechanical Engineering',
    'MTS': 'Mechatronics Engineering',
  };

  static const List<String> years = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  static const List<String> sections = [
    'A',
    'B',
    'C',
    'D',
  ];

  // Temporary students for testing.
  // Later, these will come from the Spring Boot + MySQL backend.
  static final List<Map<String, String>> students = [
    for (final department in departments)
      for (final year in years)
        for (final section in sections)
          ..._studentsFor(department, year, section),
  ];

  static final List<Map<String, dynamic>> recentAttendance = [];

  static List<Map<String, String>> studentsFor(
    String department,
    String year,
    String section,
  ) {
    return students
        .where(
          (student) =>
              student['department'] == department &&
              student['year'] == year &&
              student['section'] == section,
        )
        .toList();
  }

  static List<Map<String, String>> _studentsFor(
    String department,
    String year,
    String section,
  ) {
    final yearNumber = switch (year) {
      '1st Year' => '1',
      '2nd Year' => '2',
      '3rd Year' => '3',
      '4th Year' => '4',
      _ => '1',
    };

    final names = [
      'Arun Kumar',
      'Rahul Kumar',
      'Aisha Fathima',
      'Deva Raj',
      'Praveena S',
      'Keerthiga R',
      'Sanjay Kumar',
      'Fathima Noor',
    ];

    return List.generate(8, (index) {
      final number = (index + 1).toString().padLeft(3, '0');

      return {
        'name': names[index],
        'roll': '23${department}${yearNumber}${section}$number',
        'department': department,
        'year': year,
        'section': section,
      };
    });
  }

  static List<Map<String, String>> allStudentsForDepartment(
    String department,
  ) {
    return students
        .where((student) => student['department'] == department)
        .toList();
  }

  static List<Map<String, String>> allStudents() {
    return List<Map<String, String>>.from(students);
  }

  static int presentCountFor(String department) {
    final relevantStudents =
        students.where((s) => s['department'] == department).length;

    final absent = recentAttendance
        .where((attendance) => attendance['department'] == department)
        .fold<int>(
          0,
          (sum, attendance) =>
              sum + ((attendance['absentCount'] as int?) ?? 0),
        );

    if (relevantStudents == 0) {
      return 0;
    }

    return relevantStudents - (absent > relevantStudents
        ? relevantStudents
        : absent);
  }
}

class RoleScope {
  final String role;
  final String? department;
  final String? year;
  final String? section;
  final int? userId;

  const RoleScope({
    required this.role,
    this.department,
    this.year,
    this.section,
    this.userId,
  });
}