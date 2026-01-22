import 'package:intl/intl.dart';

class Attendance {
  final String tenlop;
  final DateTime ngaynghi;
  final String? hodemGv1;
  final String? tenGv1;
  final String? chucdanhGv1;

  Attendance({
    required this.tenlop,
    required this.ngaynghi,
    this.hodemGv1,
    this.tenGv1,
    this.chucdanhGv1,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      tenlop: json['tenlop'] ?? '',
      ngaynghi: DateTime.parse(json['ngaynghi'] ?? DateTime.now().toString()),
      hodemGv1: json['hodem_gv1'],
      tenGv1: json['ten_gv1'],
      chucdanhGv1: json['chucdanh_gv1'],
    );
  }

  String get teacherName {
    if (chucdanhGv1 != null && hodemGv1 != null && tenGv1 != null) {
      return '$chucdanhGv1. ${hodemGv1?.trim()} ${tenGv1?.trim()}'.trim();
    } else if (hodemGv1 != null && tenGv1 != null) {
      return '${hodemGv1?.trim()} ${tenGv1?.trim()}'.trim();
    } else if (tenGv1 != null) {
      return tenGv1!;
    }
    return '';
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(ngaynghi);
  }
}
