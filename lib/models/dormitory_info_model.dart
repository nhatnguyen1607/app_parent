/// Thông tin ký túc xá từ API StudentInfo (kytucxa.vku.udn.vn)
class DormitoryInfoItem {
  final String maSinhVien;
  final String hoVaTen;

  /// Chuỗi HocKy từ API (VD: "Năm học 2025-2026: Học kỳ 1") — dùng để tham khảo
  final String hocKyRaw;
  final String phong;
  final String trangThai;

  DormitoryInfoItem({
    required this.maSinhVien,
    required this.hoVaTen,
    required this.hocKyRaw,
    required this.phong,
    required this.trangThai,
  });

  factory DormitoryInfoItem.fromJson(Map<String, dynamic> json) {
    return DormitoryInfoItem(
      maSinhVien: (json['MaSinhVien'] ?? json['masinhvien'] ?? '').toString(),
      hoVaTen: (json['HoVaTen'] ?? json['hovaten'] ?? '').toString(),
      hocKyRaw: (json['HocKy'] ?? json['hocky'] ?? '').toString(),
      phong: (json['Phong'] ?? json['phong'] ?? '').toString(),
      trangThai: (json['TrangThai'] ?? json['trangthai'] ?? '').toString(),
    );
  }
}
