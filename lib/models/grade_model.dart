class Grade {
  final int namhoc;
  final int hocky;
  final String masv;
  final int? lhpId;
  final int hocphanId;
  final String tenhocphan;
  final int sotc;
  final int idlop;
  final String lanhoc;
  final String diem;
  final int trangthai;
  final double? diemt10;
  final int? diemt4;
  final String diemchu;
  final String? khaothiSokhop;

  Grade({
    required this.namhoc,
    required this.hocky,
    required this.masv,
    this.lhpId,
    required this.hocphanId,
    required this.tenhocphan,
    required this.sotc,
    required this.idlop,
    required this.lanhoc,
    required this.diem,
    required this.trangthai,
    this.diemt10,
    this.diemt4,
    required this.diemchu,
    this.khaothiSokhop,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      namhoc: json['namhoc'] ?? 0,
      hocky: json['hocky'] ?? 0,
      masv: json['masv'] ?? '',
      lhpId: json['lhp_id'],
      hocphanId: json['hocphan_id'] ?? 0,
      tenhocphan: json['tenhocphan'] ?? '',
      sotc: json['sotc'] ?? 0,
      idlop: json['idlop'] ?? 0,
      lanhoc: json['lanhoc'] ?? '',
      diem: json['diem'] ?? '',
      trangthai: json['trangthai'] ?? 0,
      diemt10: json['diemt10']?.toDouble(),
      diemt4: json['diemt4'],
      diemchu: json['diemchu'] ?? '',
      khaothiSokhop: json['khaothi_sokhop'],
    );
  }

  // Parse điểm từ chuỗi "9,9,8.5,9," thành list [CC, BT, GK, CK]
  List<String> get parsedScores {
    if (diem.isEmpty) return ['', '', '', ''];
    
    final parts = diem.split(',');
    final result = <String>[];
    
    for (int i = 0; i < 4; i++) {
      if (i < parts.length) {
        result.add(parts[i].trim());
      } else {
        result.add('');
      }
    }
    
    return result;
  }

  String get diemCC => parsedScores[0];
  String get diemBT => parsedScores[1];
  String get diemGK => parsedScores[2];
  String get diemCK => parsedScores[3];

  // Kiểm tra có hiển thị điểm cuối kỳ không
  bool get hasKhaothiSokhop => khaothiSokhop != null && khaothiSokhop!.isNotEmpty;
}

class SemesterGrades {
  final int namhoc;
  final int hocky;
  final List<Grade> grades;
  final String? semesterYearName; 

  SemesterGrades({
    required this.namhoc,
    required this.hocky,
    required this.grades,
    this.semesterYearName,
  });

  String get semesterName {
    // Nếu có tên từ API thì dùng, nếu không thì dùng cách cũ
    if (semesterYearName != null && semesterYearName!.isNotEmpty) {
      return 'Học kỳ $hocky - $semesterYearName';
    }
    // Chuyển đổi namhoc thành năm học (ví dụ: 7 -> 2023-2024)
    int startYear = 2017 + namhoc;
    return 'Học kỳ $hocky - $startYear-${startYear + 1}';
  }
}

// Model cho điểm tổng kết
class SummarySemesterGrade {
  final String masv;
  final int namhoc;
  final int hocky;
  final int sotcDK;        // Số tín chỉ đăng ký
  final int soTCMoi;       // Số tín chỉ mới
  final double diemTB4;    // Điểm trung bình thang 4
  final double diemTB10;   // Điểm trung bình thang 10
  final double diemHB;     // Điểm học bổng
  final int soTCTLhocki;   // Số tín chỉ tích lũy học kỳ
  final double diemTL4;    // Điểm tích lũy thang 4
  final double diemTL10;   // Điểm tích lũy thang 10
  final int soTCTL;        // Số tín chỉ tích lũy
  final String xeploai;    // Xếp loại
  final String? semesterYearName;

  SummarySemesterGrade({
    required this.masv,
    required this.namhoc,
    required this.hocky,
    required this.sotcDK,
    required this.soTCMoi,
    required this.diemTB4,
    required this.diemTB10,
    required this.diemHB,
    required this.soTCTLhocki,
    required this.diemTL4,
    required this.diemTL10,
    required this.soTCTL,
    required this.xeploai,
    this.semesterYearName,
  });

  factory SummarySemesterGrade.fromJson(Map<String, dynamic> json, {String? yearName}) {
    return SummarySemesterGrade(
      masv: json['masv'] ?? '',
      namhoc: json['namhoc'] ?? 0,
      hocky: json['hocky'] ?? 0,
      sotcDK: json['sotcDK'] ?? 0,
      soTCMoi: json['soTCMoi'] ?? 0,
      diemTB4: (json['diemTB4'] ?? 0).toDouble(),
      diemTB10: (json['diemTB10'] ?? 0).toDouble(),
      diemHB: (json['diemHB'] ?? 0).toDouble(),
      soTCTLhocki: json['soTCTLhocki'] ?? 0,
      diemTL4: (json['diemTL4'] ?? 0).toDouble(),
      diemTL10: (json['diemTL10'] ?? 0).toDouble(),
      soTCTL: json['soTCTL'] ?? 0,
      xeploai: json['xeploai'] ?? '',
      semesterYearName: yearName,
    );
  }

  String get semesterName {
    if (semesterYearName != null && semesterYearName!.isNotEmpty) {
      return 'Học kỳ $hocky, năm $semesterYearName';
    }
    int startYear = 2017 + namhoc;
    return 'Học kỳ $hocky, năm $startYear-${startYear + 1}';
  }
}
