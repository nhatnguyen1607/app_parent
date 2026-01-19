import '../../models/student_model.dart';
import '../../repositories/student_repository.dart';
import '../data/student_mock_data.dart';

/// Mock implementation of StudentRepository for development.
/// This entire file can be deleted when real API is ready.
class MockStudentRepository implements StudentRepository {
  @override
  Future<List<Student>> fetchStudents() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return devMockStudents;
  }
}
