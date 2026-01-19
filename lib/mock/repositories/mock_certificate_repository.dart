import '../../models/certificate_model.dart';
import '../../models/student_model.dart';
import '../../repositories/certificate_repository.dart';
import '../data/certificate_mock_data.dart';

/// Mock implementation of CertificateRepository for development.
/// This entire file can be deleted when real API is ready.
class MockCertificateRepository implements CertificateRepository {
  @override
  Future<Certificate?> fetchCertificate(Student student) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return devMockCertificate;
  }
}
