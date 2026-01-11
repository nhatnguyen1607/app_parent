import 'package:flutter/foundation.dart';
import '../models/tuition_model.dart';
import '../models/student_model.dart';
import 'tuition_repository.dart';
import '../data/mock/tuition_mock_data.dart' as mock;

class ApiTuitionRepository implements TuitionRepository {
  @override
  Future<List<TuitionRecord>> fetchTuitionPaid(Student student) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (kDebugMode) {
      return Future.value(mock.devMockTuitionPaid);
    }

    return <TuitionRecord>[]; // replace with API logic later
  }

  @override
  Future<List<TuitionRecord>> fetchTuitionRefunds(Student student) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (kDebugMode) {
      return Future.value(mock.devMockTuitionRefunds);
    }

    return <TuitionRecord>[]; // replace with API logic later
  }

  @override
  Future<List<TuitionCharge>> fetchTuitionCharges(Student student) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (kDebugMode) {
      return Future.value(mock.devMockTuitionCharges);
    }

    return <TuitionCharge>[]; // replace with API logic later
  }

  @override
  Future<QrInfo> fetchQrInfo(Student student) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (kDebugMode) {
      return Future.value(mock.devMockQrInfo);
    }

    throw UnimplementedError(); // replace with API logic later
  }
}

