import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/absence_model.dart';
import '../models/makeup_model.dart';
import '../config/app_config.dart';

class AbsenceController {
  final String _baseUrl = AppConfig.baseUrl;
  Future<List<Absence>> getAbsences(String studentCode) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/baonghi?masv=$studentCode'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true) {
          if (jsonData['info'] != null && jsonData['info'] is List) {
            final List<dynamic> infoList = jsonData['info'];
            return infoList.map((json) => Absence.fromJson(json)).toList();
          }
          return [];
        }
      }
      
      return [];
    } catch (e) {
      print('Error fetching absences: $e');
      return [];
    }
  }

  Future<List<Makeup>> getMakeups(String studentCode) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/daybu?masv=$studentCode'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true) {
          if (jsonData['info'] != null && jsonData['info'] is List) {
            final List<dynamic> infoList = jsonData['info'];
            return infoList.map((json) => Makeup.fromJson(json)).toList();
          }
          return [];
        }
      }
      
      return [];
    } catch (e) {
      print('Error fetching makeups: $e');
      return [];
    }
  }
}
