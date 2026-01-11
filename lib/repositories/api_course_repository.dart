import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../models/student_model.dart';
import 'course_repository.dart';
import '../data/mock/course_mock_data.dart' as mock;

class ApiCourseRepository implements CourseRepository {
  @override
  Future<List<Course>> fetchCourses(Student student) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (kDebugMode) {
      return Future.value(mock.devMockCourses);
    }

    return <Course>[]; // replace with API logic later
  }
}

