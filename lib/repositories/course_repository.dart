import '../models/course_model.dart';
import '../models/student_model.dart';

abstract class CourseRepository {
  Future<List<Course>> fetchCourses(Student student);
}

