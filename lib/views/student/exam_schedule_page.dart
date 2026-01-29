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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: const BoxConstraints(minWidth: 860),
          child: Column(
            children: [
              // Table header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF455A64),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 350, child: _buildHeaderCell('Tên lớp học phần', flex: 1)),
                    SizedBox(width: 150, child: _buildHeaderCell('H/thức thi cuối kỳ', flex: 1)),
                    SizedBox(width: 120, child: _buildHeaderCell('Ngày thi', flex: 1)),
                    SizedBox(width: 120, child: _buildHeaderCell('Giờ thi', flex: 1)),
                    SizedBox(width: 120, child: _buildHeaderCell('Phòng thi', flex: 1)),
                  ],
                ),
              ),
              // Table rows
              ...exams.asMap().entries.map((entry) {
                int index = entry.key;
                var exam = entry.value;
                Color bgColor = index % 2 == 0 ? Colors.white : Colors.grey[50]!;
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 350, child: _buildDataCell(exam.subject, flex: 1)),
                      SizedBox(width: 150, child: _buildDataCell(exam.examType, flex: 1)),
                      SizedBox(width: 120, child: _buildDataCell(exam.examDate, flex: 1)),
                      SizedBox(width: 120, child: _buildDataCell(exam.examTime, flex: 1)),
                      SizedBox(width: 120, child: _buildDataCell(exam.examRoom, flex: 1)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, {int flex = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.black87,
        ),
      ),
    );
  }
}
