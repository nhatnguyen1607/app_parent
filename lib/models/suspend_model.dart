class Suspend {
  final int ketquaID;
  final String masv;
  final String trangthai;
  final String lydo;
  final int namhocQd;
  final int hockyQd;
  final String quyetdinh;
  final String ngayQd;
  final int namhocBd;
  final int hockyBd;
  final int namhocTl;
  final int hockyTl;
  final int loai;
  final int giahan;

  Suspend({
    required this.ketquaID,
    required this.masv,
    required this.trangthai,
    required this.lydo,
    required this.namhocQd,
    required this.hockyQd,
    required this.quyetdinh,
    required this.ngayQd,
    required this.namhocBd,
    required this.hockyBd,
    required this.namhocTl,
    required this.hockyTl,
    required this.loai,
    required this.giahan,
  });

  factory Suspend.fromJson(Map<String, dynamic> json) {
    return Suspend(
      ketquaID: json['ketquaID'] ?? 0,
      masv: json['masv'] ?? '',
      trangthai: json['trangthai'] ?? '',
      lydo: json['lydo'] ?? '',
      namhocQd: json['namhoc_qd'] ?? 0,
      hockyQd: json['hocky_qd'] ?? 0,
      quyetdinh: json['quyetdinh'] ?? '',
      ngayQd: json['ngay_qd'] ?? '',
      namhocBd: json['namhoc_bd'] ?? 0,
      hockyBd: json['hocky_bd'] ?? 0,
      namhocTl: json['namhoc_tl'] ?? 0,
      hockyTl: json['hocky_tl'] ?? 0,
      loai: json['loai'] ?? 0,
      giahan: json['giahan'] ?? 0,
    );
  }

  String _getNamHocText(int namhoc) {
    int startYear = 2017 + namhoc;
    int endYear = startYear + 1;
    return '$startYear - $endYear';
  }

  String _getHocKyText(int hocky) {
    if (hocky == 3) {
      return 'Học kỳ hè';
    }
    return 'Học kỳ $hocky';
  }

  String get namHocQdText => _getNamHocText(namhocQd);
  String get hocKyQdText => _getHocKyText(hockyQd);
  String get namHocBdText => _getNamHocText(namhocBd);
  String get hocKyBdText => _getHocKyText(hockyBd);
  String get namHocTlText => _getNamHocText(namhocTl);
  String get hocKyTlText => _getHocKyText(hockyTl);

  String get ngayQdFormatted {
    try {
      final parts = ngayQd.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    } catch (e) {
      // ignore
    }
    return ngayQd;
  }
}
