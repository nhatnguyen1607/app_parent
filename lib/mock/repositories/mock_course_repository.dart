import '../../models/course_model.dart';
import '../../models/student_model.dart';
import '../../repositories/course_repository.dart';
import '../data/course_mock_data.dart';

/// Mock implementation of CourseRepository for development.
/// This entire file can be deleted when real API is ready.
class MockCourseRepository implements CourseRepository {
  @override
  Future<List<Course>> fetchCourses(Student student) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return devMockCourses;
  }
}
