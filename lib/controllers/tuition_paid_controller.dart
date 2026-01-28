import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tuition_paid_model.dart';
import 'schedule_controller.dart';
import '../config/app_config.dart';

class TuitionPaidController {
  final ScheduleController _scheduleController = ScheduleController();
  final String _baseUrl = AppConfig.baseUrl;
  /// Lấy danh sách học phí đã nộp từ API hocphidanop và gắn "học kỳ năm" từ namhochocky
  Future<List<TuitionPaidItem>> getTuitionPaid(String masv) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/hocphidanop?masv=$masv',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Không kết nối được server (mã ${response.statusCode})');
      }

      final body = json.decode(response.body);
      if (body is! Map<String, dynamic>) {
        throw Exception('Dữ liệu trả về không hợp lệ');
      }
      if (body['success'] != true) {
        return [];
      }

      final info = body['info'];
      if (info is! List || info.isEmpty) return [];

      final semesters = await _scheduleController.getAllSemesters();
      final mapHocKyNam = <String, String>{};
      for (final s in semesters) {
        final id = s['id'] is int ? s['id'] as int : 0;
        final hk = s['hocky'] is int ? s['hocky'] as int : 1;
        mapHocKyNam['${id}_$hk'] = s['namhocText'] is String ? s['namhocText'] as String : '';
      }

      String resolveHocKyNam(int namhoc, int hocky) {
        return mapHocKyNam['${namhoc}_$hocky'] ?? '';
      }

      return info
          .map((e) => TuitionPaidItem.fromJson(
                Map<String, dynamic>.from(e as Map),
                resolveHocKyNam: resolveHocKyNam,
              ))
          .toList();
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Lỗi tải học phí đã nộp: $e');
    }
  }
}
