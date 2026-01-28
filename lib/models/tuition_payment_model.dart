// Model cho Học phí sắp tới
class UpcomingTuition {
  final String tenLop;
  final int soTC;
  final String lanHoc;
  final int thanhTien;

  UpcomingTuition({
    required this.tenLop,
    required this.soTC,
    required this.lanHoc,
    required this.thanhTien,
  });

  factory UpcomingTuition.fromJson(Map<String, dynamic> json) {
    return UpcomingTuition(
      tenLop: json['tenlop'] ?? '',
      soTC: json['soTC'] ?? 0,
      lanHoc: json['lanhoc']?.toString() ?? '',
      thanhTien: json['thanh_tien'] ?? 0,
    );
  }
}
