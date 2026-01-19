import '../config/app_config.dart';

// Abstract interfaces
import 'student_repository.dart';
import 'course_repository.dart';
import 'tuition_repository.dart';
import 'certificate_repository.dart';

// Real API implementations
import 'api_student_repository.dart';
import 'api_course_repository.dart';
import 'api_tuition_repository.dart';
import 'api_certificate_repository.dart';

// Mock implementations (can be deleted when API is ready)
import '../mock/repositories/mock_student_repository.dart';
import '../mock/repositories/mock_course_repository.dart';
import '../mock/repositories/mock_tuition_repository.dart';
import '../mock/repositories/mock_certificate_repository.dart';

/// Repository provider - returns Mock or Real API based on AppConfig.useMockApi
///
/// Configuration:
/// - Set USE_MOCK_API=true in .env to use mock data
/// - Set USE_MOCK_API=false in .env to use real API
///
/// When API is ready:
/// 1. Delete the entire lib/mock/ folder
/// 2. Remove the mock imports above
/// 3. Set USE_MOCK_API=false in .env
/// 4. Simplify this file to only return API implementations

StudentRepository getStudentRepository() =>
    AppConfig.useMockApi ? MockStudentRepository() : ApiStudentRepository();

CourseRepository getCourseRepository() =>
    AppConfig.useMockApi ? MockCourseRepository() : ApiCourseRepository();

TuitionRepository getTuitionRepository() =>
    AppConfig.useMockApi ? MockTuitionRepository() : ApiTuitionRepository();

CertificateRepository getCertificateRepository() => AppConfig.useMockApi
    ? MockCertificateRepository()
    : ApiCertificateRepository();
