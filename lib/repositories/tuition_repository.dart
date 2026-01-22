import '../models/tuition_model.dart';
import '../models/student_model.dart';

abstract class TuitionRepository {
  Future<List<TuitionRecord>> fetchTuitionPaid(Student student);
  Future<List<TuitionRecord>> fetchTuitionRefunds(Student student);
  Future<List<TuitionCharge>> fetchTuitionCharges(Student student);
  Future<QrInfo> fetchQrInfo(Student student);
}

/// Real API implementation of TuitionRepository.
/// TODO: Implement actual API calls when backend is ready.
class ApiTuitionRepository implements TuitionRepository {
  @override
  Future<List<TuitionRecord>> fetchTuitionPaid(Student student) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not yet implemented');
  }

  @override
  Future<List<TuitionRecord>> fetchTuitionRefunds(Student student) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not yet implemented');
  }

  @override
  Future<List<TuitionCharge>> fetchTuitionCharges(Student student) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not yet implemented');
  }

  @override
  Future<QrInfo> fetchQrInfo(Student student) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not yet implemented');
  }
}

