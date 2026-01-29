import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exam_schedule_model.dart';
import '../config/app_config.dart';

class ExamScheduleController {
  final String _baseUrl = AppConfig.baseUrl;
  
  Future<List<ExamSchedule>> getExamSchedule(String masv) async {
    try {
      final url = Uri.parse('$_baseUrl/lichthi?masv=$masv');
      
      print('DEBUG: Fetching exam schedule from: $url');
      
      final response = await http.get(url);
      
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Server trả về mã lỗi ${response.statusCode}');
      }

      final decoded = utf8.decode(response.bodyBytes, allowMalformed: true);
      final data = json.decode(decoded);
      
      print('DEBUG: Decoded data: $data');

      // Kiểm tra data = 0 mới hiển thị thông tin
      if (data['data'] == 0) {
        if (data['info'] != null && data['info'] is List) {
          final List<dynamic> infoList = data['info'];
          
          if (infoList.isNotEmpty) {
            return infoList
                .map((item) => ExamSchedule.fromJson(item as Map<String, dynamic>))
                .toList();
          }
        }
        // data = 0 nhưng info rỗng = chưa có lịch thi
        return [];
      } else {
        // data = 1 hoặc khác 0 = lỗi từ API
        throw Exception('API trả về lỗi: data = ${data['data']}');
      }
    } catch (e) {
      print('ERROR fetching exam schedule: $e');
      rethrow; // Throw lại để FutureBuilder bắt được error
    }
  }
}
