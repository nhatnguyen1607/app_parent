import '../models/certificate_model.dart';
import '../models/student_model.dart';

abstract class CertificateRepository {
  Future<Certificate?> fetchCertificate(Student student);
}

