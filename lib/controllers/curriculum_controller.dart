import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/curriculum_model.dart';
import '../config/app_config.dart';

class CurriculumController {
  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? 0;
    return 0;
  }
  final String _baseUrl = AppConfig.baseUrl;
  /// Lấy chương trình học từ API chuongtrinh?masv= (danh sách + moreinfo.sotctoithieu)
  Future<CurriculumResult> getCurriculum(String masv) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/chuongtrinh?masv=$masv',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Không kết nối được server (mã ${response.statusCode})');
      }

      final decoded = utf8.decode(response.bodyBytes, allowMalformed: true);
      final body = json.decode(decoded);

      int sotctoithieu = 160;
      List<dynamic> rawList = [];

      if (body is Map) {
        final moreinfo = body['moreinfo'];
        if (moreinfo is Map && moreinfo['sotctoithieu'] != null) {
          sotctoithieu = _asInt(moreinfo['sotctoithieu']);
        }
        final info = body['info'] ?? body['data'];
        if (info is List) {
          rawList = info;
        }
        // data = 0 hoặc null → rawList giữ []
      } else if (body is List) {
        rawList = body;
      }

      final items = rawList
          .map((e) => CurriculumItem.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
      return CurriculumResult(items: items, sotctoithieu: sotctoithieu);
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Lỗi tải chương trình học: $e');
    }
  }
}
