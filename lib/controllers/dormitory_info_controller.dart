import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dormitory_info_model.dart';

class DormitoryInfoController {
  /// Lấy thông tin ký túc xá từ API StudentInfo
  /// https://kytucxa.vku.udn.vn/home/API/StudentInfo?MaSinhVien=
  Future<List<DormitoryInfoItem>> getStudentInfo(String maSinhVien) async {
    try {
      final url = Uri.parse(
        'https://kytucxa.vku.udn.vn/home/API/StudentInfo?MaSinhVien=$maSinhVien',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception(
          'Không kết nối được server (mã ${response.statusCode})',
        );
      }

      final decoded = utf8.decode(response.bodyBytes, allowMalformed: true);
      final body = json.decode(decoded);

      if (body is Map) {
        if (body['error'] == 1) {
          final message = (body['message'] ?? '').toString();
          if (message.isNotEmpty) {
            throw Exception(message);
          }
          return [];
        }
        final data = body['data'] ?? body['info'];
        if (data is List) {
          return data
              .map(
                (e) => DormitoryInfoItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList();
        }
        return [];
      }

      if (body is List) {
        return body
            .map(
              (e) => DormitoryInfoItem.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      }

      return [];
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Lỗi tải thông tin ký túc xá: $e');
    }
  }
}
