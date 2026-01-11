import 'package:flutter/foundation.dart';
import '../models/student_model.dart';
import 'student_repository.dart';
import '../data/mock/student_mock_data.dart' as mock;

class ApiStudentRepository implements StudentRepository {
  // TODO: Implement actual API calls when backend is ready.
  // For now, return mock data in debug mode so developers see realistic content.
  @override
  Future<List<Student>> fetchStudents() async {
    // simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    if (kDebugMode) {
      // Use dev-only mock data during development. Remove when API is ready.
      return Future.value(mock.devMockStudents);
    }

    return <Student>[]; // replace with API logic later
  }
}
