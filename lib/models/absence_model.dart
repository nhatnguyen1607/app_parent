class Absence {
  final String tenlop;
  final String thoidiembaonghi;
  final String lydo;

  Absence({
    required this.tenlop,
    required this.thoidiembaonghi,
    required this.lydo,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      tenlop: json['tenlop'] ?? '',
      thoidiembaonghi: json['thoidiembaonghi'] ?? '',
      lydo: json['lydo'] ?? '',
    );
  }

  String get thoidiemFormatted {
    try {
      // Format: "2026-01-05 11:01:16"
      final parts = thoidiembaonghi.split(' ');
      if (parts.length == 2) {
        final dateParts = parts[0].split('-');
        final timeParts = parts[1].split(':');
        if (dateParts.length == 3 && timeParts.length >= 2) {
          return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]} ${timeParts[0]}:${timeParts[1]}';
        }
      }
    } catch (e) {
      // ignore
    }
    return thoidiembaonghi;
  }
}
