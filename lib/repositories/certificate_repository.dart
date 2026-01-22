import '../models/certificate_model.dart';
import '../models/student_model.dart';

abstract class CertificateRepository {
  Future<Certificate?> fetchCertificate(Student student);
}

/// Real API implementation of CertificateRepository.
/// TODO: Implement actual API calls when backend is ready.
class ApiCertificateRepository implements CertificateRepository {
  @override
  Future<Certificate?> fetchCertificate(Student student) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not yet implemented');
  }
}

