import 'package:flutter/material.dart';
import '../models/student_model.dart';
import 'student/schedule_page.dart';
import 'student/attendance_page.dart';
import 'student/exam_schedule_page.dart';
import 'student/curriculum_page.dart';
import 'student/tuition_paid_page.dart';
import 'student/tuition_upcoming_page.dart';
import 'student/tuition_payment_page.dart';
import 'student/certificate_page.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
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
                    child: widget.student.avatarUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.network(
                              widget.student.avatarUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey[400],
                          ),
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
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
                    _InfoItem('Khoa:', widget.student.faculty),
                    _InfoItem('Khóa học:', widget.student.academicYear),
                    _InfoItem('Ngày sinh:', widget.student.dateOfBirth),
                  ]),

                  const SizedBox(height: 24),
                  const Text(
                    'Thông tin học phí, chuyên cần, rèn luyện',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213C73),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoCard([
                    _InfoItem('Tiền học phí đã nộp:', '0 đ'),
                    _InfoItem('Tiền học phí còn nợ:', 'Còn nợ: 7,926,400đ đ'),
                    _InfoItem('Số buổi vắng:', '0'),
                    _InfoItem('Chi tiết buổi vắng:', '---'),
                    _InfoItem('Khen thưởng:', 'Không'),
                    _InfoItem('Kỷ luật:', 'Không'),
                  ]),

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
                  _buildSemesterGrades(),
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
              decoration: const BoxDecoration(
                color: Color(0xFF1A2F5A),
              ),
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
                    child: widget.student.avatarUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              widget.student.avatarUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey[400],
                          ),
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
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
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
            _buildDrawerItem(Icons.account_balance_wallet, 'Học phí sắp tới', 6),
            _buildDrawerItem(Icons.money, 'Đóng học phí', 7),
            _buildDrawerItem(Icons.verified, 'Chứng chỉ tốt nghiệp', 8),
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
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
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
          case 6: // Học phí sắp tới
            page = TuitionUpcomingPage(student: widget.student);
            break;
          case 7: // Đóng học phí
            page = TuitionPaymentPage(student: widget.student);
            break;
          case 8: // Chứng chỉ tốt nghiệp
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
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
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
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterGrades() {
    return Column(
      children: [
        _buildSemesterSection('Học kỳ riêng - Quy đổi', 'Học kỳ 1 - 2023-2024', [
          {'name': 'Tiếng Anh chuyên ngành 1IT ✓', 'credit': '1', 'cc': '9', 'bt': '9', 'gk': '8.5', 'ck': '9', 't10': '8.9', 'chu': 'A'},
          {'name': 'Nhập môn ngành và kỹ năng mềm IT ✓', 'credit': '1', 'cc': '9', 'bt': '', 'gk': '', 'ck': '8.5', 't10': '8.65', 'chu': 'A'},
          {'name': 'Cơ sở dữ liệu ✓', 'credit': '1', 'cc': '9', 'bt': '8', 'gk': '8.5', 'ck': '5.2', 't10': '6.8', 'chu': 'C'},
          {'name': 'Tiếng Anh 1 ✓', 'credit': '1', 'cc': '10', 'bt': '', 'gk': '10', 'ck': '7.0', 't10': '8.2', 'chu': 'B'},
          {'name': 'Lập trình hướng đối tượng ✓', 'credit': '1', 'cc': '10', 'bt': '8', 'gk': '7.5', 'ck': '9', 't10': '8.6', 'chu': 'A'},
          {'name': 'Lập trình cơ bản ✓', 'credit': '1', 'cc': '10', 'bt': '10', 'gk': '8.5', 'ck': '10', 't10': '9.7', 'chu': 'A'},
          {'name': 'Giải tích 1 ✓', 'credit': '1', 'cc': '10', 'bt': '', 'gk': '10', 'ck': '10', 't10': '10', 'chu': 'A'},
        ]),
        const SizedBox(height: 24),
        _buildSemesterSection('Học kỳ riêng - Quy đổi', 'Học kỳ 2 - 2023-2024', [
          {'name': 'Tiếng Anh 2 ✓', 'credit': '1', 'cc': '10', 'bt': '', 'gk': '9.1', 'ck': '8.7', 't10': '9', 'chu': 'A'},
          {'name': 'Khởi nghiệp và đổi mới sáng tạo ✓', 'credit': '1', 'cc': '9', 'bt': '', 'gk': '8.5', 'ck': '8', 't10': '8.3', 'chu': 'B'},
          {'name': 'Lập trình Python ✓', 'credit': '1', 'cc': '10', 'bt': '9', 'gk': '9', 'ck': '9.5', 't10': '9.4', 'chu': 'A'},
          {'name': 'Cấu trúc dữ liệu và giải thuật ✓', 'credit': '1', 'cc': '10', 'bt': '8.5', 'gk': '7.5', 'ck': '7', 't10': '7.7', 'chu': 'B'},
          {'name': 'Tiếng Anh chuyên ngành 2 ✓', 'credit': '1', 'cc': '9', 'bt': '9', 'gk': '9', 'ck': '8.7', 't10': '8.9', 'chu': 'A'},
        ]),
        const SizedBox(height: 24),
        _buildSemesterSection('Học kỳ riêng - Quy đổi', 'Học kỳ 1 - 2024-2025', [
          {'name': 'Mạng máy tính ✓', 'credit': '1', 'cc': '10', 'bt': '9', 'gk': '9', 'ck': '7', 't10': '8.1', 'chu': 'B'},
          {'name': 'Pháp luật đại cương ✓', 'credit': '1', 'cc': '10', 'bt': '', 'gk': '8.5', 'ck': '9', 't10': '9.1', 'chu': 'A'},
          {'name': 'Giải tích 2 ✓', 'credit': '1', 'cc': '10', 'bt': '', 'gk': '10', 'ck': '10', 't10': '10', 'chu': 'A'},
          {'name': 'Vật lý ✓', 'credit': '1', 'cc': '10', 'bt': '8.7', 'gk': '8', 'ck': '8.5', 't10': '8.6', 'chu': 'A'},
        ]),
        const SizedBox(height: 24),
        _buildSemesterSection('Học kỳ riêng - Quy đổi', 'Học kỳ 2 - 2024-2025', [
          {'name': 'Toán rời rạc ✓', 'credit': '1', 'cc': '10', 'bt': '9', 'gk': '8.5', 'ck': '10', 't10': '9.5', 'chu': 'A'},
          {'name': 'Trí tuệ nhân tạo ✓', 'credit': '1', 'cc': '10', 'bt': '7.5', 'gk': '9', 'ck': '9.5', 't10': '9.1', 'chu': 'A'},
          {'name': 'Lập trình di động ✓', 'credit': '1', 'cc': '10', 'bt': '10', 'gk': '9.5', 'ck': '9', 't10': '9.4', 'chu': 'A'},
          {'name': 'Tiếng Anh nâng cao 2 ✓', 'credit': '1', 'cc': '10', 'bt': '', 'gk': '8.3', 'ck': '7.8', 't10': '8.3', 'chu': 'B'},
        ]),
      ],
    );
  }

  Widget _buildSemesterSection(String title, String semester, List<Map<String, String>> courses) {
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
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
            decoration: const BoxDecoration(
              color: Color(0xFFC8E6C9),
            ),
            child: Text(
              semester,
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
              constraints: const BoxConstraints(minWidth: 800),
              child: Column(
                children: [
                  // Table header
                  Container(
                    color: const Color(0xFF455A64),
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                        1: FixedColumnWidth(280),
                        2: FixedColumnWidth(70),
                        3: FixedColumnWidth(90),
                        4: FixedColumnWidth(80),
                        5: FixedColumnWidth(90),
                        6: FixedColumnWidth(120),
                        7: FixedColumnWidth(80),
                        8: FixedColumnWidth(80),
                      },
                      children: [
                        TableRow(
                          children: [
                            _buildGradeTableHeader('#'),
                            _buildGradeTableHeader('Tên lớp học phần'),
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
                      2: FixedColumnWidth(70),
                      3: FixedColumnWidth(90),
                      4: FixedColumnWidth(80),
                      5: FixedColumnWidth(90),
                      6: FixedColumnWidth(120),
                      7: FixedColumnWidth(80),
                      8: FixedColumnWidth(80),
                    },
                    children: courses.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, String> course = entry.value;
                      Color bgColor = index % 2 == 0 ? Colors.white : Colors.grey[50]!;
                      return TableRow(
                        decoration: BoxDecoration(color: bgColor),
                        children: [
                          _buildGradeTableCell('${index + 1}'),
                          _buildGradeTableCell(course['name']!, align: TextAlign.left),
                          _buildGradeTableCell(course['credit']!),
                          _buildGradeTableCell(course['cc']!),
                          _buildGradeTableCell(course['bt']!),
                          _buildGradeTableCell(course['gk']!),
                          _buildGradeTableCell(course['ck']!),
                          _buildGradeTableCell(course['t10']!),
                          _buildGradeTableCell(
                            course['chu']!,
                            color: course['chu'] == 'A' ? Colors.green : (course['chu'] == 'B' ? Colors.blue : Colors.black87),
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

  Widget _buildGradeTableCell(String text, {TextAlign align = TextAlign.center, Color? color, bool bold = false}) {
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
