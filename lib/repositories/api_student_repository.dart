import '../models/student_model.dart';
import 'student_repository.dart';

class ApiStudentRepository implements StudentRepository {
  // TODO: Implement actual API calls when backend is ready.
  // For now return an empty list (safe default) so replacing mock won't crash the app.
  @override
  Future<List<Student>> fetchStudents() async {
    // simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return <Student>[]; // replace with API logic later
  }
}
