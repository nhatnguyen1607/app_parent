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

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final s = v.trim();
      return int.tryParse(s) ?? int.tryParse(s.replaceAll(RegExp(r'[^0-9\-]'), '')) ?? 0;
    }
    return 0;
  }

  factory UpcomingTuition.fromJson(Map<String, dynamic> json) {
    return UpcomingTuition(
      tenLop: (json['tenlop'] ?? json['ten_lop'] ?? json['tenLop'] ?? '').toString(),
      soTC: _asInt(json['soTC'] ?? json['sotc'] ?? json['so_tc']),
      lanHoc: (json['lanhoc'] ?? json['lan_hoc'] ?? json['lanHoc'] ?? '').toString(),
      thanhTien: _asInt(json['thanh_tien'] ?? json['thanhtien'] ?? json['thanhTien']),
    );
  }
}
