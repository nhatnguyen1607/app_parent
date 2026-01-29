import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/suspend_model.dart';
import '../config/app_config.dart';

class SuspendController {
  final String _baseUrl = AppConfig.baseUrl;
  Future<List<Suspend>> getSuspends(String studentCode) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/tamdung?masv=$studentCode'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true) {
          // Nếu có field 'info' thì parse danh sách tạm dừng
          if (jsonData['info'] != null && jsonData['info'] is List) {
            final List<dynamic> infoList = jsonData['info'];
            return infoList.map((json) => Suspend.fromJson(json)).toList();
          }
          // Nếu không có field 'info' (data = 1), trả về danh sách rỗng
          return [];
        }
      }
      
      return [];
    } catch (e) {
      print('Error fetching suspends: $e');
      return [];
    }
  }
}
