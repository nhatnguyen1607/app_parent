import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tuition_payment_model.dart';
import '../config/app_config.dart';

class TuitionPaymentController {
  /// Lấy danh sách học phí sắp tới từ API hocphisapden
  final String _baseUrl = AppConfig.baseUrl;
  Future<List<UpcomingTuition>> getUpcomingTuition(String masv) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/hocphisapden?masv=$masv',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Không kết nối được server (mã ${response.statusCode})');
      }

      final body = json.decode(response.body);

      // API hocphisapden trả về List trực tiếp
      if (body is List) {
        return body
            .map((e) => UpcomingTuition.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
      }

      return [];
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi tải học phí sắp tới: $e');
    }
  }
}
