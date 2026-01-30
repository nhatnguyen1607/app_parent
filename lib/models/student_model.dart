class Student {
  final String id;
  final String name;
  final String studentCode;
  final String className;
  final String major;
  final String dateOfBirth;
  final String? avatarUrl;
  final String GVCN;
  final String email_gv;
  final String phone_gv;

  Student({
    required this.id,
    required this.name,
    required this.studentCode,
    required this.className,
    required this.major,
    required this.dateOfBirth,
    this.avatarUrl,
    required this.GVCN,
    required this.email_gv,
    required this.phone_gv,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    // Format date from yyyy-MM-dd to dd/MM/yyyy
    String formatDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) return '';
      try {
        final parts = dateString.split('-');
        if (parts.length == 3) {
          return '${parts[2]}/${parts[1]}/${parts[0]}';
        }
        return dateString;
      } catch (e) {
        return dateString;
      }
    }

    return Student(
      id: json['id']?.toString() ?? '',
      name: '${json['hodem'] ?? ''} ${json['ten'] ?? ''}'.trim(),
      studentCode: json['masv'] ?? '',
      className: json['tenlop'] ?? '',
      major: json['tennganh'] ?? '',
      GVCN:
          '${json['chucdanh'] ?? ''}${'.'}  ${json['hodemgv'] ?? ''} ${json['tengv'] ?? ''}'
              .trim(),
      email_gv: json['emailgv'] ?? '',
      phone_gv: '0${json['phonegv'] ?? ''}'.trim(),
      dateOfBirth: formatDate(json['ngaysinh']), 
      avatarUrl: json['avatar'],
    );
  }

  // String get GVCN => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'studentCode': studentCode,
      'className': className,
      'major': major,
      'dateOfBirth': dateOfBirth,
      'avatarUrl': avatarUrl,
    };
  }
}
