import 'student_repository.dart';
import 'api_student_repository.dart';
import 'course_repository.dart';
import 'api_course_repository.dart';
import 'tuition_repository.dart';
import 'api_tuition_repository.dart';
import 'certificate_repository.dart';
import 'api_certificate_repository.dart';

// Repository provider - returns API implementations by default
// When API is ready, just update the implementations here
// Tests should inject test mocks directly

StudentRepository getStudentRepository() => ApiStudentRepository();
CourseRepository getCourseRepository() => ApiCourseRepository();
TuitionRepository getTuitionRepository() => ApiTuitionRepository();
CertificateRepository getCertificateRepository() => ApiCertificateRepository();
