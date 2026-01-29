class Warning {
  final int canhbaoID;
  final String masv;
  final String quyetdinh;
  final String ngay;
  final int namhoc;
  final int hocky;
  final String lydo;
  final int type;

  Warning({
    required this.canhbaoID,
    required this.masv,
    required this.quyetdinh,
    required this.ngay,
    required this.namhoc,
    required this.hocky,
    required this.lydo,
    required this.type,
  });

  factory Warning.fromJson(Map<String, dynamic> json) {
    return Warning(
      canhbaoID: json['canhbaoID'] ?? 0,
      masv: json['masv'] ?? '',
      quyetdinh: json['quyetdinh'] ?? '',
      ngay: json['ngay'] ?? '',
      namhoc: json['namhoc'] ?? 0,
      hocky: json['hocky'] ?? 0,
      lydo: json['lydo'] ?? '',
      type: json['type'] ?? 0,
    );
  }

  String get namHocText {
    int startYear = 2017 + namhoc;
    int endYear = startYear + 1;
    return '$startYear - $endYear';
  }

  String get hocKyText {
    if (hocky == 3) {
      return 'Học kỳ hè';
    }
    return 'Học kỳ $hocky';
  }

  String get ngayFormatted {
    try {
      final parts = ngay.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    } catch (e) {
      // ignore
    }
    return ngay;
  }
}
