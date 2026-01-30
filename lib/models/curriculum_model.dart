/// Kết quả API chuongtrinh: danh sách môn + moreinfo (sotctoithieu)
class CurriculumResult {
  final List<CurriculumItem> items;
  final int sotctoithieu;

  CurriculumResult({required this.items, this.sotctoithieu = 160});
}

/// Mục chương trình học từ API chuongtrinh
class CurriculumItem {
  final String tenhocphan;
  final int soTC;
  final int tuchon; // 0 = Bắt buộc, 1 = Tự chọn
  final int hocky;
  final String tenkhoiluongkienthuc;

  CurriculumItem({
    required this.tenhocphan,
    required this.soTC,
    required this.tuchon,
    required this.hocky,
    required this.tenkhoiluongkienthuc,
  });

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? 0;
    return 0;
  }

  factory CurriculumItem.fromJson(Map<String, dynamic> json) {
    return CurriculumItem(
      tenhocphan: (json['tenhocphan'] ?? json['ten_hoc_phan'] ?? '').toString(),
      soTC: _asInt(json['soTC'] ?? json['sotc'] ?? json['so_tc']),
      tuchon: _asInt(json['tuchon'] ?? json['tu_chon'] ?? 0),
      hocky: _asInt(json['hocky'] ?? json['hoc_ky'] ?? json['hocKy'] ?? 0),
      tenkhoiluongkienthuc: (json['tenkhoiluongkienthuc'] ??
              json['ten_khoi_luong_kien_thuc'] ??
              '')
          .toString(),
    );
  }

  String get loaiHocPhan => tuchon == 1 ? 'Tự chọn' : 'Bắt buộc';
}
