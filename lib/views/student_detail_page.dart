import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../models/grade_model.dart';
import '../controllers/grade_controller.dart';
import 'student/schedule_page.dart';
import 'student/attendance_page.dart';
import 'student/exam_schedule_page.dart';
import 'student/curriculum_page.dart';
import 'student/tuition_paid_page.dart';
import 'student/tuition_payment_page.dart';
import 'student/certificate_page.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  final GradeController _gradeController = GradeController();
  List<SemesterGrades> _semesterGrades = [];
  List<SummarySemesterGrade> _summaryGrades = [];
  bool _isLoadingGrades = true;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades() async {
    setState(() {
      _isLoadingGrades = true;
    });

    final grades = await _gradeController.getStudentGrades(
      widget.student.studentCode,
    );
    final summaryGrades = await _gradeController.getSummaryGrades(
      widget.student.studentCode,
    );

    setState(() {
      _semesterGrades = grades;
      _summaryGrades = summaryGrades;
      _isLoadingGrades = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin chi tiết',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF213C73),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header với ảnh và thông tin cơ bản
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF213C73),
                    const Color(0xFF213C73).withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child:
                        (widget.student.avatarUrl != null &&
                            widget.student.avatarUrl!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.network(
                              widget.student.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.grey[400],
                                );
                              },
                            ),
                          )
                        : Icon(Icons.person, size: 80, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.student.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.student.studentCode,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Thông tin chi tiết
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THÔNG TIN SINH VIÊN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213C73),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard([
                    _InfoItem('Mã Sinh viên:', widget.student.studentCode),
                    _InfoItem('Lớp sinh hoạt:', widget.student.className),
                    _InfoItem('Ngành/Chuyên ngành:', widget.student.major),
                    _InfoItem('Ngày sinh:', widget.student.dateOfBirth),
                  ]),

                  // const SizedBox(height: 24),
                  // const Text(
                  //   'Thông tin học phí, chuyên cần, rèn luyện',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color(0xFF213C73),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),

                  // _buildInfoCard([
                  //   _InfoItem('Tiền học phí đã nộp:', '0 đ'),
                  //   _InfoItem('Tiền học phí còn nợ:', 'Còn nợ: 7,926,400đ đ'),
                  //   _InfoItem('Số buổi vắng:', '0'),
                  //   _InfoItem('Chi tiết buổi vắng:', '---'),
                  //   _InfoItem('Khen thưởng:', 'Không'),
                  //   _InfoItem('Kỷ luật:', 'Không'),
                  // ]),
                  const SizedBox(height: 24),
                  const Text(
                    'Điểm tổng kết',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213C73),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bảng điểm tổng kết
                  _isLoadingGrades
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _summaryGrades.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'Chưa có dữ liệu điểm tổng kết',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        )
                      : _buildSummaryTable(),

                  const SizedBox(height: 24),
                  const Text(
                    'Điểm các lớp học phần',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213C73),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Để xem điểm thành phần, sau khi Phòng KT&ĐBCLGD chốt điểm, sinh viên phải thực hiện đánh giá lớp học phần và sẽ cần thiết của học phần.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Điểm theo từng kỳ
                  _isLoadingGrades
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _semesterGrades.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'Chưa có dữ liệu điểm',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        )
                      : _buildSemesterGrades(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF213C73),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1A2F5A)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child:
                        (widget.student.avatarUrl != null &&
                            widget.student.avatarUrl!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              widget.student.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey[400],
                                );
                              },
                            ),
                          )
                        : Icon(Icons.person, size: 40, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.student.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.student.studentCode,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.info, 'Thông tin chung', 0),
            _buildDrawerItem(Icons.calendar_today, 'Thời khóa biểu', 1),
            _buildDrawerItem(Icons.check_circle, 'Tình trạng chuyên cần', 2),
            _buildDrawerItem(Icons.event, 'Lịch thi', 3),
            _buildDrawerItem(Icons.book, 'Chương trình học', 4),
            _buildDrawerItem(Icons.payment, 'Học phí đã nộp', 5),
            _buildDrawerItem(Icons.money, 'Đóng học phí', 6),
            _buildDrawerItem(Icons.verified, 'Chứng chỉ tốt nghiệp', 7),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.arrow_back, color: Colors.white),
              title: const Text(
                'Quay lại',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);

        // Điều hướng đến trang tương ứng
        Widget? page;
        switch (index) {
          case 0: // Thông tin chung - đã ở đây rồi
            return;
          case 1: // Thời khóa biểu
            page = SchedulePage(student: widget.student);
            break;
          case 2: // Tình trạng chuyên cần
            page = AttendancePage(student: widget.student);
            break;
          case 3: // Lịch thi
            page = ExamSchedulePage(student: widget.student);
            break;
          case 4: // Chương trình học
            page = CurriculumPage(student: widget.student);
            break;
          case 5: // Học phí đã nộp
            page = TuitionPaidPage(student: widget.student);
            break;
          case 6: // Đóng học phí
            page = TuitionPaymentPage(student: widget.student);
            break;
          case 77: // Chứng chỉ tốt nghiệp
            page = CertificatePage(student: widget.student);
            break;
        }

        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page!),
          );
        }
      },
    );
  }

  Widget _buildInfoCard(List<_InfoItem> items) {
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
      child: Column(
        children: items
            .map((item) => _buildInfoRow(item.label, item.value))
            .toList(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterGrades() {
    return Column(
      children: _semesterGrades.asMap().entries.map((entry) {
        int index = entry.key;
        SemesterGrades semesterGrade = entry.value;

        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            _buildSemesterSection(semesterGrade),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSemesterSection(SemesterGrades semesterGrade) {
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
      child: Column(
        children: [
          // Header màu xanh lá
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF81C784),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              'Học kỳ riêng - Quy đổi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Semester title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(color: Color(0xFFC8E6C9)),
            child: Text(
              semesterGrade.semesterName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Scrollable table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: const BoxConstraints(minWidth: 1000),
              child: Column(
                children: [
                  // Table header
                  Container(
                    color: const Color(0xFF455A64),
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                        1: FixedColumnWidth(280),
                        2: FixedColumnWidth(80),
                        3: FixedColumnWidth(80),
                        4: FixedColumnWidth(100),
                        5: FixedColumnWidth(100),
                        6: FixedColumnWidth(100),
                        7: FixedColumnWidth(140),
                        8: FixedColumnWidth(90),
                        9: FixedColumnWidth(90),
                      },
                      children: [
                        TableRow(
                          children: [
                            _buildGradeTableHeader('#'),
                            _buildGradeTableHeader('Tên lớp học phần'),
                            _buildGradeTableHeader('Số TC'),
                            _buildGradeTableHeader('Lần học'),
                            _buildGradeTableHeader('Điểm CC / GVHD'),
                            _buildGradeTableHeader('Điểm Bài tập'),
                            _buildGradeTableHeader('Điểm Giữa kỳ'),
                            _buildGradeTableHeader('Điểm Cuối kỳ / Đồ án'),
                            _buildGradeTableHeader('Điểm T10'),
                            _buildGradeTableHeader('Điểm Chữ'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Table rows
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(50),
                      1: FixedColumnWidth(280),
                      2: FixedColumnWidth(80),
                      3: FixedColumnWidth(80),
                      4: FixedColumnWidth(100),
                      5: FixedColumnWidth(100),
                      6: FixedColumnWidth(100),
                      7: FixedColumnWidth(140),
                      8: FixedColumnWidth(90),
                      9: FixedColumnWidth(90),
                    },
                    children: semesterGrade.grades.asMap().entries.map((entry) {
                      int index = entry.key;
                      Grade grade = entry.value;
                      Color bgColor = index % 2 == 0
                          ? Colors.white
                          : Colors.grey[50]!;

                      // Thêm dấu ✓ nếu có điểm
                      String courseName = grade.tenhocphan;
                      if (grade.diemt10 != null && grade.diemt10! > 0) {
                        courseName += ' ✓';
                      }

                      return TableRow(
                        decoration: BoxDecoration(color: bgColor),
                        children: [
                          _buildGradeTableCell('${index + 1}'),
                          _buildGradeTableCell(
                            courseName,
                            align: TextAlign.left,
                          ),
                          _buildGradeTableCell(grade.sotc.toString()),
                          _buildGradeTableCell(grade.lanhoc),
                          _buildGradeTableCell(grade.diemCC),
                          _buildGradeTableCell(grade.diemBT),
                          _buildGradeTableCell(grade.diemGK),
                          _buildGradeTableCell(grade.diemCK),
                          _buildGradeTableCell(grade.diemt10?.toString() ?? ''),
                          _buildGradeTableCell(
                            grade.diemchu,
                            color: grade.diemchu == 'A'
                                ? Colors.green
                                : (grade.diemchu == 'B'
                                      ? Colors.blue
                                      : (grade.diemchu == 'C'
                                            ? Colors.orange
                                            : (grade.diemchu == 'D'
                                                  ? Colors.red[700]!
                                                  : (grade.diemchu == 'F'
                                                        ? Colors.red
                                                        : Colors.black87)))),
                            bold: true,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTable() {
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
                color: const Color(0xFF455A64),
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(50),
                    1: FixedColumnWidth(180),
                    2: FixedColumnWidth(90),
                    3: FixedColumnWidth(90),
                    4: FixedColumnWidth(90),
                    5: FixedColumnWidth(120),
                    6: FixedColumnWidth(120),
                    7: FixedColumnWidth(120),
                  },
                  children: [
                    TableRow(
                      children: [
                        _buildGradeTableHeader('#'),
                        _buildGradeTableHeader('Học kỳ'),
                        _buildGradeTableHeader('Điểm 4'),
                        _buildGradeTableHeader('Điểm 10'),
                        _buildGradeTableHeader('Xếp loại'),
                        _buildGradeTableHeader('Điểm 4 TL'),
                        _buildGradeTableHeader('Điểm 10 TL'),
                        _buildGradeTableHeader('Số TC TL'),
                      ],
                    ),
                  ],
                ),
              ),
              // Table rows
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(50),
                  1: FixedColumnWidth(180),
                  2: FixedColumnWidth(90),
                  3: FixedColumnWidth(90),
                  4: FixedColumnWidth(90),
                  5: FixedColumnWidth(120),
                  6: FixedColumnWidth(120),
                  7: FixedColumnWidth(120),
                },
                children: _summaryGrades.asMap().entries.map((entry) {
                  int index = entry.key;
                  SummarySemesterGrade summary = entry.value;
                  Color bgColor = index % 2 == 0
                      ? Colors.white
                      : Colors.grey[50]!;

                  // Màu cho xếp loại
                  Color xeploaiColor = Colors.black87;
                  if (summary.xeploai == 'Xuất sắc') {
                    xeploaiColor = Colors.green;
                  } else if (summary.xeploai == 'Giỏi') {
                    xeploaiColor = Colors.blue;
                  } else if (summary.xeploai == 'Khá') {
                    xeploaiColor = Colors.orange;
                  }

                  return TableRow(
                    decoration: BoxDecoration(color: bgColor),
                    children: [
                      _buildGradeTableCell('${index + 1}'),
                      _buildGradeTableCell(
                        summary.semesterName,
                        align: TextAlign.left,
                      ),
                      // Điểm trung bình hệ 4
                      _buildGradeTableCell(summary.diemTB4.toStringAsFixed(2)),

                      // Điểm trung bình hệ 10
                      _buildGradeTableCell(summary.diemTB10.toStringAsFixed(2)),

                      _buildGradeTableCell(
                        summary.xeploai,
                        color: xeploaiColor,
                        bold: true,
                      ),

                      // Điểm tích lũy hệ 4
                      _buildGradeTableCell(summary.diemTL4.toStringAsFixed(2)),

                      // Điểm tích lũy hệ 10
                      _buildGradeTableCell(summary.diemTL10.toStringAsFixed(2)),

                      // Số tín chỉ (thường là số nguyên hoặc .5 nên có thể giữ nguyên hoặc format tùy ý)
                      _buildGradeTableCell(summary.soTCTL.toString()),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradeTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
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

  Widget _buildGradeTableCell(
    String text, {
    TextAlign align = TextAlign.center,
    Color? color,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 11,
          color: color ?? Colors.black87,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}
