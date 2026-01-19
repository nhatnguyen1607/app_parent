import '../models/tuition_model.dart';
import '../models/student_model.dart';

abstract class TuitionRepository {
  Future<List<TuitionRecord>> fetchTuitionPaid(Student student);
  Future<List<TuitionRecord>> fetchTuitionRefunds(Student student);
  Future<List<TuitionCharge>> fetchTuitionCharges(Student student);
  Future<QrInfo> fetchQrInfo(Student student);
}

