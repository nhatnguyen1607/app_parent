import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/attendance_model.dart';

class AttendanceController {
  final String _baseUrl = AppConfig.baseUrl;

  // Lấy kỳ và năm học hiện hành
  Future<Map<String, dynamic>> getCurrentSemester() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/namhochocky?namhoc=&hocky='),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true && data['info'] != null) {
          final List<dynamic> infoList = data['info'];
          
          // Tìm kỳ hiện hành (hienhanh = 1)
          for (var item in infoList) {
            if (item['hienhanh'] == 1) {
              return {
                'namhoc': int.tryParse(item['id']?.toString() ?? '0') ?? 0,
                'hocky': int.tryParse(item['hocky']?.toString() ?? '1') ?? 1,
                'namhocText': '${item['nambatdau']}-${item['namketthuc']}',
              };
            }
          }
          
          // Nếu không tìm thấy, lấy item đầu tiên
          if (infoList.isNotEmpty) {
            final first = infoList.first;
            return {
              'namhoc': int.tryParse(first['id']?.toString() ?? '0') ?? 0,
              'hocky': int.tryParse(first['hocky']?.toString() ?? '1') ?? 1,
              'namhocText': '${first['nambatdau']}-${first['namketthuc']}',
            };
          }
        }
      }
      
      return {'namhoc': 0, 'hocky': 1, 'namhocText': ''};
    } catch (e) {
      print('Error fetching current semester: $e');
      return {'namhoc': 0, 'hocky': 1, 'namhocText': ''};
    }
  }

  // Lấy danh sách tất cả năm học và học kỳ
  Future<List<Map<String, dynamic>>> getAllSemesters() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/namhochocky?namhoc=&hocky='),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true && data['info'] != null) {
          final List<dynamic> infoList = data['info'];
          
          return infoList.map((item) {
            return {
              'id': int.tryParse(item['id']?.toString() ?? '0') ?? 0,
              'namhoc': int.tryParse(item['namhoc']?.toString() ?? '0') ?? 0,
              'hocky': int.tryParse(item['hocky']?.toString() ?? '1') ?? 1,
              'nambatdau': item['nambatdau'] ?? '',
              'namketthuc': item['namketthuc'] ?? '',
              'namhocText': '${item['nambatdau']}-${item['namketthuc']}',
              'hienhanhnam': int.tryParse(item['hienhanhnam']?.toString() ?? '0') ?? 0,
              'hienhanhhocky': int.tryParse(item['hienhanhhocky']?.toString() ?? '0') ?? 0,
            };
          }).toList();
        }
      }
      
      return [];
    } catch (e) {
      print('Error fetching all semesters: $e');
      return [];
    }
  }

  // Lấy tình trạng chuyên cần
  Future<List<Attendance>> getAttendance(String masv, int namhoc, int hocky) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/chuyencan?masv=$masv&namhoc=$namhoc&hocky=$hocky'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true && data['info'] != null) {
          final List<dynamic> infoList = data['info'];
          
          final attendances = infoList.map((item) => Attendance.fromJson(item)).toList();
          
          // Sắp xếp theo ngày nghỉ (từ cũ đến mới)
          attendances.sort((a, b) => a.ngaynghi.compareTo(b.ngaynghi));
          
          return attendances;
        }
      }
      
      return [];
    } catch (e) {
      print('Error fetching attendance: $e');
      return [];
    }
  }
}
