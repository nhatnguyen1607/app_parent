import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/exam_schedule_model.dart';
import '../../controllers/exam_schedule_controller.dart';
import '../../controllers/schedule_controller.dart';

class ExamSchedulePage extends StatefulWidget {
  final Student student;

  const ExamSchedulePage({super.key, required this.student});

  @override
  State<ExamSchedulePage> createState() => _ExamSchedulePageState();
}

class _ExamSchedulePageState extends State<ExamSchedulePage> {
  late Future<List<ExamSchedule>> _examScheduleFuture;
  late Future<Map<String, dynamic>> _currentSemesterFuture;
  final ExamScheduleController _controller = ExamScheduleController();
  final ScheduleController _scheduleController = ScheduleController();

  @override
  void initState() {
    super.initState();
    
    // Wrap với timeout để tránh treo mãi
    _examScheduleFuture = Future.delayed(Duration.zero, () async {
      try {
        return await _controller
            .getExamSchedule(widget.student.studentCode)
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw Exception('Timeout: Không kết nối được sau 10 giây');
              },
            );
      } catch (e) {
        // Ném lại để FutureBuilder bắt được
        rethrow;
      }
    });
    
    _currentSemesterFuture = _scheduleController.getCurrentSemester();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Đổi background thành trắng thay vì xám
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: _currentSemesterFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                'Lịch thi kết thúc học kỳ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              );
            }

            final semester = snapshot.data ?? {};
            final hocky = semester['hocky'] ?? 1;
            final namhocText = semester['namhocText'] ?? '';

            String title = 'Lịch thi kết thúc học kỳ $hocky';
            if (namhocText.isNotEmpty) {
              title += ', năm học $namhocText';
            }

            return Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            );
          },
        ),
        backgroundColor: const Color(0xFF213C73),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Sinh viên thường xuyên theo dõi ',
                            ),
                            TextSpan(
                              text: 'TKB trên website của Phòng KT&ĐBCLGD',
                              style: TextStyle(
                                color: Colors.blue[700],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(
                              text: ' và ',
                            ),
                            TextSpan(
                              text: 'Lịch thi Đào tạo',
                              style: TextStyle(
                                color: Colors.blue[700],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(
                              text: ' để nắm thông tin thời gian thi kết thúc học phần. Chi tiết danh sách phòng thi từng môn sẽ được cập nhật trước 3-7 ngày tổ chức thi.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<ExamSchedule>>(
                future: _examScheduleFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Đang tải lịch thi...'),
                          ],
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Không thể tải lịch thi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              'Lỗi: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _examScheduleFuture = Future.delayed(Duration.zero, () async {
                                    return await _controller
                                        .getExamSchedule(widget.student.studentCode)
                                        .timeout(
                                          const Duration(seconds: 10),
                                          onTimeout: () => throw Exception('Timeout'),
                                        );
                                  });
                                });
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Thử lại'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final exams = snapshot.data ?? [];
                  
                  if (exams.isEmpty) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Chưa có lịch thi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Lịch thi sẽ được cập nhật trong thời gian tới',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return _buildExamTable(exams);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamTable(List<ExamSchedule> exams) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: exams.asMap().entries.map((entry) {
          int index = entry.key;
          var exam = entry.value;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF455A64),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      exam.subject,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF213C73),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Thông tin
              _buildInfoRow('Hình thức thi', exam.examType),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow('Ngày thi', exam.examDate),
                  ),
                  Expanded(
                    child: _buildInfoRow('Giờ thi', exam.examTime),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _buildInfoRow('Phòng thi', exam.examRoom),
            ],
          ),
        );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
