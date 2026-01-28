/// Một bản ghi học phí đã nộp từ API hocphidanop
class TuitionPaidItem {
  final String sobienlai;
  final int tongtien;
  final String ngaythuDisplay; // dd/MM/yyyy
  final int namhoc;
  final int hocky;
  final String hocKyNamText; // "nambatdau-namketthuc" từ API namhochocky

  TuitionPaidItem({
    required this.sobienlai,
    required this.tongtien,
    required this.ngaythuDisplay,
    required this.namhoc,
    required this.hocky,
    required this.hocKyNamText,
  });

  /// Format ngày từ "2024-01-03 09:30:00" thành "03/01/2024"
  static String formatDateOnly(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final datePart = dateString.split(' ').first;
      final parts = datePart.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return datePart;
    } catch (_) {
      return dateString;
    }
  }

  factory TuitionPaidItem.fromJson(
    Map<String, dynamic> json, {
    String Function(int namhoc, int hocky)? resolveHocKyNam,
  }) {
    final namhoc = int.tryParse(json['namhoc']?.toString() ?? '0') ?? 0;
    final hocky = int.tryParse(json['hocky']?.toString() ?? '1') ?? 1;
    final tongtienRaw = json['tongtien'];
    int tongtien = 0;
    if (tongtienRaw != null) {
      if (tongtienRaw is int) {
        tongtien = tongtienRaw;
      } else {
        tongtien = int.tryParse(tongtienRaw.toString()) ?? 0;
      }
    }

    return TuitionPaidItem(
      sobienlai: json['sobienlai']?.toString() ?? '',
      tongtien: tongtien,
      ngaythuDisplay: formatDateOnly(json['ngaythu']?.toString()),
      namhoc: namhoc,
      hocky: hocky,
      hocKyNamText: resolveHocKyNam != null ? resolveHocKyNam(namhoc, hocky) : '',
    );
  }
}
