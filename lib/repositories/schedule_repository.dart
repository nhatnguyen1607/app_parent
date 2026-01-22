import '../models/schedule_model.dart';
import '../controllers/schedule_controller.dart';

class ScheduleRepository {
  final ScheduleController _controller = ScheduleController();

  // Lấy kỳ và năm học hiện hành
  Future<Map<String, dynamic>> getCurrentSemester() async {
    return await _controller.getCurrentSemester();
  }

  // Lấy danh sách tất cả năm học và học kỳ
  Future<List<Map<String, dynamic>>> getAllSemesters() async {
    return await _controller.getAllSemesters();
  }

  // Lấy thời khóa biểu
  Future<List<Schedule>> getSchedule(String masv, int namhoc, int hocky) async {
    return await _controller.getSchedule(masv, namhoc, hocky);
  }
}
