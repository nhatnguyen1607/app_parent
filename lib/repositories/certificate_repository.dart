import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/certificate_model.dart';
import '../models/student_model.dart';

abstract class CertificateRepository {
  Future<Certificate?> fetchCertificate(Student student);
}

/// Real API implementation of CertificateRepository.
class ApiCertificateRepository implements CertificateRepository {
  @override
  Future<Certificate?> fetchCertificate(Student student) async {
    try {
      final masv = student.studentCode;
      final url = Uri.parse(
        'https://daotao.vku.udn.vn/phuhuynh/api/chungchi?masv=$masv',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['info'] != null) {
          final List<dynamic> infoList = data['info'];

          if (infoList.isNotEmpty) {
            final info = infoList[0];

            return Certificate(
              studentName: student.name,
              physicalEducation: info['thechat']?.toString(),
              nationalDefense: info['quocphong']?.toString(),
              foreignLanguage: info['ngoaingu']?.toString(),
              informatics: info['tinhoc']?.toString(),
            );
          }
        }
      }

      return null;
    } catch (e) {
      print('Error fetching certificate: $e');
      return null;
    }
  }
}

