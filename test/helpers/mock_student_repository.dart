import 'package:app_parent/repositories/student_repository.dart';
import 'package:app_parent/models/student_model.dart';
import 'mock_data.dart';

class MockStudentRepository implements StudentRepository {
  @override
  Future<List<Student>> fetchStudents() async {
    return Future.value(mockStudents);
  }
}
