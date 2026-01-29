class Schedule {
  final int idlop;
  final String tenlop;
  final String tuan;
  final String phong;
  final String thu;
  final String tiet;
  final String? hodemGv1;
  final String? tenGv1;
  final String? chucdanhGv1;
  final String? hodemGv2;
  final String? tenGv2;
  final String? chucdanhGv2;

  Schedule({
    required this.idlop,
    required this.tenlop,
    required this.tuan,
    required this.phong,
    required this.thu,
    required this.tiet,
    this.hodemGv1,
    this.tenGv1,
    this.chucdanhGv1,
    this.hodemGv2,
    this.tenGv2,
    this.chucdanhGv2,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      idlop: json['idlop'] ?? 0,
      tenlop: json['tenlop'] ?? '',
      tuan: json['tuan'] ?? '',
      phong: json['phong'] ?? '',
      thu: json['thu'] ?? '',
      tiet: json['tiet'] ?? '',
      hodemGv1: json['hodem_gv1'],
      tenGv1: json['ten_gv1'],
      chucdanhGv1: json['chucdanh_gv1'],
      hodemGv2: json['hodem_gv2'],
      tenGv2: json['ten_gv2'],
      chucdanhGv2: json['chucdanh_gv2'],
    );
  }

  String get teacherName {
    String teacher1 = '';
    if (chucdanhGv1 != null && hodemGv1 != null && tenGv1 != null) {
      teacher1 = '$chucdanhGv1. ${hodemGv1?.trim()} ${tenGv1?.trim()}'.trim();
    }

    if (hodemGv2 != null && tenGv2 != null && hodemGv2!.isNotEmpty && tenGv2!.isNotEmpty) {
      String teacher2 = '';
      if (chucdanhGv2 != null) {
        teacher2 = '$chucdanhGv2. ${hodemGv2?.trim()} ${tenGv2?.trim()}'.trim();
      } else {
        teacher2 = '${hodemGv2?.trim()} ${tenGv2?.trim()}'.trim();
      }
      return '$teacher1, $teacher2';
    }

    return teacher1;
  }

  // Chuyển đổi tiết thành buổi
  String get timeSession {
    if (tiet.isEmpty || tiet == '_') return '';
    
    // Parse tiết (format: "1->3" hoặc "8->9")
    final parts = tiet.split('->');
    if (parts.length < 2) return '';
    
    final firstPeriod = int.tryParse(parts[0].trim()) ?? 0;
    final secondPeriod = int.tryParse(parts[1].trim()) ?? 0;
    
    if (firstPeriod == 0 || secondPeriod == 0) return '';
    
    // Sáng: Tiết 1-5 (07h30 - 11h30)
    // Chiều: Tiết 6-10 (13h00 - 17h00)
    if (firstPeriod >= 1 && firstPeriod <= 5) {
      final times = ['07h30', '08h30', '09h30', '10h30', '11h30'];
      if (secondPeriod <= 5 && secondPeriod >= 1) {
        return 'Từ ${times[firstPeriod - 1]} -> ${times[secondPeriod - 1]}';
      }
    } else if (firstPeriod >= 6 && firstPeriod <= 10) {
      final times = ['13h', '14h', '15h', '16h', '17h'];
      if (secondPeriod >= 6 && secondPeriod <= 10) {
        return 'Từ ${times[firstPeriod - 6]} -> ${times[secondPeriod - 6]}';
      }
    }
    
    return '';
  }
}
