import '../models/grade_model.dart';
import '../controllers/grade_controller.dart';

/// Repository layer cho Grade - chỉ đóng vai trò data source wrapper
/// Logic xử lý API đã được chuyển sang GradeController
class GradeRepository {
  final GradeController _controller = GradeController();

  Future<List<SemesterGrades>> getStudentGrades(String masv) async {
    return await _controller.getStudentGrades(masv);
  }

  Future<List<SummarySemesterGrade>> getSummaryGrades(String masv) async {
    return await _controller.getSummaryGrades(masv);
  }
}
