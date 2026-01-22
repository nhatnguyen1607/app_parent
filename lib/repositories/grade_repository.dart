import '../models/grade_model.dart';
import '../controllers/grade_controller.dart';

class GradeRepository {
  final GradeController _controller = GradeController();

  Future<List<SemesterGrades>> getStudentGrades(String masv) async {
    return await _controller.getStudentGrades(masv);
  }

  Future<List<SummarySemesterGrade>> getSummaryGrades(String masv) async {
    return await _controller.getSummaryGrades(masv);
  }
}
