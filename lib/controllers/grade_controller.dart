import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/grade_model.dart';

class GradeController {
  final String _baseUrl = AppConfig.baseUrl;

  // Lấy danh sách năm học từ API
  Future<Map<int, String>> getAcademicYears() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/namhochocky?namhoc=&hocky='),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true && data['info'] != null) {
          final List<dynamic> infoList = data['info'];
          final Map<int, String> yearMap = {};
          
          for (var item in infoList) {
            final int id = item['id'] ?? 0;
            final String nambatdau = item['nambatdau'] ?? '';
            final String namketthuc = item['namketthuc'] ?? '';
            
            if (nambatdau.isNotEmpty && namketthuc.isNotEmpty && 
                nambatdau != '_' && namketthuc != '_') {
              yearMap[id] = '$nambatdau-$namketthuc';
            }
          }
          
          return yearMap;
        }
      }
      
      return {};
    } catch (e) {
      print('Error fetching academic years: $e');
      return {};
    }
  }

  Future<List<SemesterGrades>> getStudentGrades(String masv) async {
    try {
      // Lấy danh sách năm học trước
      final yearMap = await getAcademicYears();
      
      final response = await http.get(
        Uri.parse('$_baseUrl/diemlophocphan?masv=$masv'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true && data['info'] != null) {
          final List<dynamic> infoList = data['info'];
          
          // Parse tất cả các Grade
          final allGrades = infoList
              .map((item) => Grade.fromJson(item))
              .toList();
          
          // Group theo namhoc và hocky
          final Map<String, List<Grade>> groupedGrades = {};
          final Map<String, int> semesterIds = {}; // Lưu ID của từng semester
          
          for (var grade in allGrades) {
            final key = '${grade.namhoc}_${grade.hocky}';
            if (!groupedGrades.containsKey(key)) {
              groupedGrades[key] = [];
              // Lưu ID tương ứng với namhoc (sử dụng ID từ grade đầu tiên)
              // Cần tìm cách map namhoc_key từ API với namhoc trong grade
              semesterIds[key] = grade.namhoc;
            }
            groupedGrades[key]!.add(grade);
          }
          
          // Chuyển thành list SemesterGrades và sắp xếp
          final semesterGradesList = groupedGrades.entries.map((entry) {
            final parts = entry.key.split('_');
            final namhoc = int.parse(parts[0]);
            final hocky = int.parse(parts[1]);
            
            // Lấy tên năm học từ yearMap dựa trên ID
            // Giả sử namhoc tương ứng với ID trong API
            String? yearName = yearMap[namhoc];
            
            return SemesterGrades(
              namhoc: namhoc,
              hocky: hocky,
              grades: entry.value,
              semesterYearName: yearName,
            );
          }).toList();
          
          // Sắp xếp theo namhoc và hocky (từ nhỏ đến lớn)
          semesterGradesList.sort((a, b) {
            if (a.namhoc != b.namhoc) {
              return a.namhoc.compareTo(b.namhoc);
            }
            return a.hocky.compareTo(b.hocky);
          });
          
          return semesterGradesList;
        }
      }
      
      return [];
    } catch (e) {
      print('Error fetching grades: $e');
      return [];
    }
  }

  Future<List<SummarySemesterGrade>> getSummaryGrades(String masv) async {
    try {
      // Lấy danh sách năm học trước
      final yearMap = await getAcademicYears();
      
      final response = await http.get(
        Uri.parse('$_baseUrl/diemhocvu?masv=$masv'),
      );

      print('Summary grades API response status: ${response.statusCode}');
      print('Summary grades API response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        print('Summary grades parsed data: $data');
        
        if (data['success'] == true && data['info'] != null) {
          final List<dynamic> infoList = data['info'];
          
          print('Summary grades info list length: ${infoList.length}');
          
          // Parse tất cả các summary grades
          final summaryGrades = infoList.map((item) {
            final int namhoc = item['namhoc'] ?? 0;
            String? yearName = yearMap[namhoc];
            return SummarySemesterGrade.fromJson(item, yearName: yearName);
          }).toList();
          
          // Sắp xếp theo namhoc và hocky
          summaryGrades.sort((a, b) {
            if (a.namhoc != b.namhoc) {
              return a.namhoc.compareTo(b.namhoc);
            }
            return a.hocky.compareTo(b.hocky);
          });
          
          print('Summary grades count: ${summaryGrades.length}');
          
          return summaryGrades;
        } else {
          print('Summary grades: success is false or info is null');
        }
      } else {
        print('Summary grades API failed with status: ${response.statusCode}');
      }
      
      return [];
    } catch (e) {
      print('Error fetching summary grades: $e');
      return [];
    }
  }
}
