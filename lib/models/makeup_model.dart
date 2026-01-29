class Makeup {
  final String tenlop;
  final String tiet;
  final dynamic phong;
  final String ngaybaobu;

  Makeup({
    required this.tenlop,
    required this.tiet,
    required this.phong,
    required this.ngaybaobu,
  });

  factory Makeup.fromJson(Map<String, dynamic> json) {
    return Makeup(
      tenlop: json['tenlop'] ?? '',
      tiet: json['tiet'] ?? '',
      phong: json['phong'] ?? '',
      ngaybaobu: json['ngaybaobu'] ?? '',
    );
  }

  String get phongText => phong.toString();

  String get ngayFormatted {
    try {
      // Format: "2026-01-26 00:00:00"
      final parts = ngaybaobu.split(' ');
      if (parts.isNotEmpty) {
        final dateParts = parts[0].split('-');
        if (dateParts.length == 3) {
          return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
        }
      }
    } catch (e) {
      // ignore
    }
    return ngaybaobu;
  }
}
