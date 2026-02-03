import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../models/grade_model.dart';
import '../models/warning_model.dart';
import '../models/suspend_model.dart';
import '../controllers/grade_controller.dart';
import '../controllers/warning_controller.dart';
import '../controllers/suspend_controller.dart';
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
  final WarningController _warningController = WarningController();
  final SuspendController _suspendController = SuspendController();
  List<SemesterGrades> _semesterGrades = [];
  List<SummarySemesterGrade> _summaryGrades = [];
  List<Warning> _warnings = [];
  List<Suspend> _suspends = [];
  bool _isLoadingGrades = true;
  bool _isLoadingWarnings = true;
  bool _isLoadingSuspends = true;

  @override
  void initState() {
    super.initState();
    _loadGrades();
    _loadWarnings();
    _loadSuspends();
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

  Future<void> _loadWarnings() async {
    setState(() {
      _isLoadingWarnings = true;
    });

    final warnings = await _warningController.getWarnings(
      widget.student.studentCode,
    );

    setState(() {
      _warnings = warnings;
      _isLoadingWarnings = false;
    });
  }

  Future<void> _loadSuspends() async {
    setState(() {
      _isLoadingSuspends = true;
    });

    final suspends = await _suspendController.getSuspends(
      widget.student.studentCode,
    );

    setState(() {
      _suspends = suspends;
      _isLoadingSuspends = false;
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

                  const SizedBox(height: 24),
                  const Text(
                    'CẢNH BÁO KẾT QUẢ HỌC TẬP',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213C73),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _isLoadingWarnings
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _warnings.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green[700], size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Không có cảnh báo học tập',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildWarningsSection(),

                  const SizedBox(height: 24),
                  const Text(
                    'TẠM DỪNG HỌC TẬP',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213C73),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _isLoadingSuspends
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _suspends.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green[700], size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Không có tạm dừng học tập',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildSuspendsSection(),

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
          case 7: // Chứng chỉ tốt nghiệp
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
    // Separate special semester (namhoc=0, hocky=0) from regular semesters
    SemesterGrades? specialSemester;
    List<SemesterGrades> regularSemesters = [];

    for (var semester in _semesterGrades) {
      // Check if this is the special semester by checking namhoc=0
      if (semester.namhoc == 0) {
        specialSemester = semester;
      } else {
        regularSemesters.add(semester);
      }
    }

    return Column(
      children: [
        // Always show special semester section
        _buildSpecialSemesterSection(specialSemester),
        const SizedBox(height: 24),
        // Show regular semesters
        ...regularSemesters.asMap().entries.map((entry) {
          int index = entry.key;
          SemesterGrades semesterGrade = entry.value;

          return Column(
            children: [
              if (index > 0) const SizedBox(height: 24),
              _buildSemesterSection(semesterGrade, isSpecial: false),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSpecialSemesterSection(SemesterGrades? semesterGrade) {
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
          // Header màu xanh lá for special semester
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
          // Grade cards or empty message
          Padding(
            padding: const EdgeInsets.all(8),
            child: semesterGrade == null || semesterGrade.grades.isEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    child: Center(
                      child: Text(
                        'Không có dữ liệu',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  )
                : Column(
              children: semesterGrade.grades.asMap().entries.map((entry) {
                int index = entry.key;
                Grade grade = entry.value;

                // Màu cho điểm chữ
                Color gradeColor = Colors.black87;
                if (grade.diemchu == 'A') {
                  gradeColor = Colors.green;
                } else if (grade.diemchu == 'B') {
                  gradeColor = Colors.blue;
                } else if (grade.diemchu == 'C') {
                  gradeColor = Colors.orange;
                } else if (grade.diemchu == 'D') {
                  gradeColor = Colors.red[700]!;
                } else if (grade.diemchu == 'F') {
                  gradeColor = Colors.red;
                } else if (grade.diemchu == 'R') {
                  gradeColor = Colors.grey;
                }

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
                      // Tên môn học
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
                              grade.tenhocphan,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF213C73),
                              ),
                            ),
                          ),
                          if (grade.diemchu.isNotEmpty && grade.diemchu != 'R')
                            Icon(Icons.check_circle, color: gradeColor, size: 18),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Thông tin điểm
                      Row(
                        children: [
                          Expanded(
                            child: _buildGradeInfo('Tín chỉ', grade.sotc.toString()),
                          ),
                          Expanded(
                            child: _buildGradeInfo('Lần học', grade.lanhoc),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGradeInfo('Điểm CC', grade.diemCC),
                          ),
                          Expanded(
                            child: _buildGradeInfo('Điểm BT', grade.diemBT),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGradeInfo('Điểm GK', grade.diemGK),
                          ),
                          Expanded(
                            child: _buildGradeInfo('Điểm CK', grade.diemCK),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      // Điểm tổng kết
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Điểm T10',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                grade.diemt10?.toString() ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF213C73),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey[300],
                          ),
                          Column(
                            children: [
                              Text(
                                'Điểm chữ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                grade.diemchu,
                                style: TextStyle(
                                      fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: gradeColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterSection(SemesterGrades semesterGrade, {bool isSpecial = false}) {
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
          // Semester title only (no "Học kỳ riêng - Quy đổi" header for regular semesters)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFC8E6C9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
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
          // Grade cards
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: semesterGrade.grades.asMap().entries.map((entry) {
                int index = entry.key;
                Grade grade = entry.value;

                // Màu cho điểm chữ
                Color gradeColor = Colors.black87;
                if (grade.diemchu == 'A') {
                  gradeColor = Colors.green;
                } else if (grade.diemchu == 'B') {
                  gradeColor = Colors.blue;
                } else if (grade.diemchu == 'C') {
                  gradeColor = Colors.orange;
                } else if (grade.diemchu == 'D') {
                  gradeColor = Colors.red[700]!;
                } else if (grade.diemchu == 'F') {
                  gradeColor = Colors.red;
                }

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
                      // Tên môn học
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
                              grade.tenhocphan,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF213C73),
                              ),
                            ),
                          ),
                          if (grade.diemt10 != null && grade.diemt10! > 0)
                            const Icon(Icons.check_circle, color: Colors.green, size: 18),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Thông tin điểm
                      Row(
                        children: [
                          Expanded(
                            child: _buildGradeInfo('Tín chỉ', grade.sotc.toString()),
                          ),
                          Expanded(
                            child: _buildGradeInfo('Lần học', grade.lanhoc),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGradeInfo('Điểm CC', grade.diemCC),
                          ),
                          Expanded(
                            child: _buildGradeInfo('Điểm BT', grade.diemBT),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGradeInfo('Điểm GK', grade.diemGK),
                          ),
                          Expanded(
                            child: _buildGradeInfo('Điểm CK', grade.diemCK),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      // Điểm tổng kết
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Điểm T10',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                grade.diemt10?.toString() ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF213C73),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey[300],
                          ),
                          Column(
                            children: [
                              Text(
                                'Điểm chữ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                grade.diemchu,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: gradeColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTable() {
    return Column(
      children: _summaryGrades.asMap().entries.map((entry) {
        int index = entry.key;
        SummarySemesterGrade summary = entry.value;

        // Màu cho xếp loại
        Color xeploaiColor = Colors.black87;
        if (summary.xeploai == 'Xuất sắc') {
          xeploaiColor = Colors.green;
        } else if (summary.xeploai == 'Giỏi') {
          xeploaiColor = Colors.blue;
        } else if (summary.xeploai == 'Khá') {
          xeploaiColor = Colors.orange;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header học kỳ
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF455A64),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      summary.semesterName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF213C73),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Điểm trung bình
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Điểm trung bình học kỳ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreBox('Hệ 4', summary.diemTB4.toStringAsFixed(2)),
                        _buildScoreBox('Hệ 10', summary.diemTB10.toStringAsFixed(2)),
                        _buildScoreBox('Xếp loại', summary.xeploai, color: xeploaiColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Điểm tích lũy
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Điểm tích lũy',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreBox('Hệ 4', summary.diemTL4.toStringAsFixed(2)),
                        _buildScoreBox('Hệ 10', summary.diemTL10.toStringAsFixed(2)),
                        _buildScoreBox('TCTL', summary.soTCTL.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScoreBox(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? const Color(0xFF213C73),
          ),
        ),
      ],
    );
  }
  Widget _buildWarningsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: _warnings.asMap().entries.map((entry) {
          int index = entry.key;
          Warning warning = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.1),
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
                        color: Colors.red[700],
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
                        '${warning.namHocText} - ${warning.hocKyText}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                    Icon(Icons.warning, color: Colors.red[700], size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                // Thông tin
                _buildWarningInfo('Số quyết định', warning.quyetdinh),
                const SizedBox(height: 6),
                _buildWarningInfo('Ngày quyết định', warning.ngayFormatted),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.red[700], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lý do',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              warning.lydo,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSuspendsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: _suspends.asMap().entries.map((entry) {
          int index = entry.key;
          Suspend suspend = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.1),
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
                        color: Colors.orange[700],
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
                        suspend.trangthai,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    ),
                    // Icon(Icons.pause_circle, color: Colors.orange[700], size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                // Thông tin quyết định
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quyết định',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildSuspendInfo('Năm học', suspend.namHocQdText),
                      const SizedBox(height: 4),
                      _buildSuspendInfo('Học kỳ', suspend.hocKyQdText),
                      const SizedBox(height: 4),
                      _buildSuspendInfo('Số QĐ', suspend.quyetdinh),
                      const SizedBox(height: 4),
                      _buildSuspendInfo('Ngày QĐ', suspend.ngayQdFormatted),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Thời gian tạm dừng
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.play_arrow, color: Colors.orange[700], size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Bắt đầu',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              suspend.namHocBdText,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              suspend.hocKyBdText,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.assignment_return, color: Colors.green[700], size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Trở lại',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              suspend.namHocTlText,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              suspend.hocKyTlText,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Lý do
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey[700], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lý do',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              suspend.lydo,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSuspendInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGradeInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 9,
          color: color ?? Colors.black87,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}
