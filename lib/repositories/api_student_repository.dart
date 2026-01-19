import '../models/student_model.dart';
import 'student_repository.dart';

/// Real API implementation of StudentRepository.
/// TODO: Implement actual API calls when backend is ready.
class ApiStudentRepository implements StudentRepository {
  @override
  Future<List<Student>> fetchStudents() async {
    // TODO: Implement real API call
    // Example:
    // final response = await http.get(Uri.parse('$baseUrl/students'));
    // return (jsonDecode(response.body) as List)
    //     .map((json) => Student.fromJson(json))
    //     .toList();

    throw UnimplementedError('Real API not yet implemented');
  }
}
