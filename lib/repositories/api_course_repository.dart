import '../models/course_model.dart';
import '../models/student_model.dart';
import 'course_repository.dart';

/// Real API implementation of CourseRepository.
/// TODO: Implement actual API calls when backend is ready.
class ApiCourseRepository implements CourseRepository {
  @override
  Future<List<Course>> fetchCourses(Student student) async {
    // TODO: Implement real API call
    // Example:
    // final response = await http.get(Uri.parse('$baseUrl/students/${student.id}/courses'));
    // return (jsonDecode(response.body) as List)
    //     .map((json) => Course.fromJson(json))
    //     .toList();

    throw UnimplementedError('Real API not yet implemented');
  }
}
