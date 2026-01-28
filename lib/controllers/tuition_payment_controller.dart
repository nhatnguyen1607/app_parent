import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/tuition_payment_model.dart';

class TuitionPaymentController {
  /// Lấy danh sách học phí sắp tới từ API hocphisapden
  Future<List<UpcomingTuition>> getUpcomingTuition(String masv) async {
    try {
      final url = Uri.parse(
        'https://daotao.vku.udn.vn/phuhuynh/api/hocphisapden?masv=$masv',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Không kết nối được server (mã ${response.statusCode})');
      }

      // Một số API trả về tiếng Việt dễ lỗi encoding, decode từ bodyBytes trước.
      final decoded = utf8.decode(response.bodyBytes, allowMalformed: true);
      final body = json.decode(decoded);

      // API hocphisapden trả về List trực tiếp
      if (body is List) {
        return body
            .map((e) => UpcomingTuition.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
      }

      // Một số trường hợp trả về Map có key info/data
      if (body is Map) {
        final dynamic info = body['info'] ?? body['data'];
        if (info is List) {
          return info
              .map((e) => UpcomingTuition.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList();
        }
        // Debug nhẹ để biết shape khi dev
        if (kDebugMode) {
          // ignore: avoid_print
          print('hocphisapden unexpected shape: ${body.keys}');
        }
      }

      return [];
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi tải học phí sắp tới: $e');
    }
  }
}
