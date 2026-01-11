import 'student_repository.dart';
import 'api_student_repository.dart';

// By default return the API implementation. Tests should inject test mocks directly.
StudentRepository getStudentRepository() => ApiStudentRepository();

