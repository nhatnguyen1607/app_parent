import '../../models/tuition_model.dart';
import '../../models/student_model.dart';
import '../../repositories/tuition_repository.dart';
import '../data/tuition_mock_data.dart';

/// Mock implementation of TuitionRepository for development.
/// This entire file can be deleted when real API is ready.
class MockTuitionRepository implements TuitionRepository {
  @override
  Future<List<TuitionRecord>> fetchTuitionPaid(Student student) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return devMockTuitionPaid;
  }

  @override
  Future<List<TuitionRecord>> fetchTuitionRefunds(Student student) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return devMockTuitionRefunds;
  }

  @override
  Future<List<TuitionCharge>> fetchTuitionCharges(Student student) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return devMockTuitionCharges;
  }

  @override
  Future<QrInfo> fetchQrInfo(Student student) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return devMockQrInfo;
  }
}
