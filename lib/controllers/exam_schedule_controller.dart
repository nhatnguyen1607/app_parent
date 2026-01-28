import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exam_schedule_model.dart';
import '../config/app_config.dart';

class ExamScheduleController {
  // Lấy lịch thi từ API
  final String _baseUrl = AppConfig.baseUrl;
  Future<List<ExamSchedule>> getExamSchedule(String masv) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/lichthi?masv=$masv',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Kiểm tra data = 0 mới hiển thị thông tin, data = 1 là lỗi
        if (data['data'] == 0) {
          // Kiểm tra info có tồn tại và không rỗng
          if (data['info'] != null && data['info'] is List) {
            final List<dynamic> infoList = data['info'] as List;
            
            if (infoList.isNotEmpty) {
              return infoList
                  .map((item) => ExamSchedule.fromJson(item as Map<String, dynamic>))
                  .toList();
            }
          }
        }
        // Nếu data = 1 hoặc khác 0 thì là lỗi, trả về mảng rỗng
      }

      return [];
    } catch (e) {
      print('Error fetching exam schedule: $e');
      return [];
    }
  }
}
