class Student {
  final String id;
  final String name;
  final String studentCode;
  final String className;
  final String major;
  final String faculty;
  final String academicYear;
  final String dateOfBirth;
  final String? avatarUrl;
  final double gpa;
  final double gpa4;
  final double gpa10;
  
  Student({
    required this.id,
    required this.name,
    required this.studentCode,
    required this.className,
    required this.major,
    required this.faculty,
    required this.academicYear,
    required this.dateOfBirth,
    this.avatarUrl,
    this.gpa = 0.0,
    this.gpa4 = 0.0,
    this.gpa10 = 0.0,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      studentCode: json['studentCode'] ?? '',
      className: json['className'] ?? '',
      major: json['major'] ?? '',
      faculty: json['faculty'] ?? '',
      academicYear: json['academicYear'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      avatarUrl: json['avatarUrl'],
      gpa: (json['gpa'] ?? 0.0).toDouble(),
      gpa4: (json['gpa4'] ?? 0.0).toDouble(),
      gpa10: (json['gpa10'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'studentCode': studentCode,
      'className': className,
      'major': major,
      'faculty': faculty,
      'academicYear': academicYear,
      'dateOfBirth': dateOfBirth,
      'avatarUrl': avatarUrl,
      'gpa': gpa,
      'gpa4': gpa4,
      'gpa10': gpa10,
    };
  }
}
