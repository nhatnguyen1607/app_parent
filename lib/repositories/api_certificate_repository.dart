import 'package:flutter/foundation.dart';
import '../models/certificate_model.dart';
import '../models/student_model.dart';
import 'certificate_repository.dart';
import '../data/mock/certificate_mock_data.dart' as mock;

class ApiCertificateRepository implements CertificateRepository {
  @override
  Future<Certificate?> fetchCertificate(Student student) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (kDebugMode) {
      return Future.value(mock.devMockCertificate);
    }

    return null; // replace with API logic later
  }
}

