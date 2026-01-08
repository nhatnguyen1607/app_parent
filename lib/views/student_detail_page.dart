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
                    'Điểm tổng kết',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213C73),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bảng điểm
                  Container(
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
                    child: Table(
                      border: TableBorder.all(
                        color: Colors.grey[300]!,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1.5),
                        4: FlexColumnWidth(1.5),
                        5: FlexColumnWidth(1.5),
                        6: FlexColumnWidth(1.5),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFF213C73),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          children: [
                            _buildTableHeader('#'),
                            _buildTableHeader('Học kỳ'),
                            _buildTableHeader('Điểm 4'),
                            _buildTableHeader('Điểm 10'),
                            _buildTableHeader('Xếp loại'),
                            _buildTableHeader('Điểm 4 TL'),
                            _buildTableHeader('Điểm 10 TL'),
                          ],
                        ),
                        _buildGradeRow('1', 'Học kỳ 1, năm 2023 - 2024', '3.5', '8.61', '6161', '3.5', '8.61'),
                        _buildGradeRow('2', 'Học kỳ 2, năm 2023 - 2024', '3.75', '8.88', 'xuất sắc', '3.63', '8.75'),
                        _buildGradeRow('3', 'Học kỳ 1, năm 2024 - 2025', '3.6', '8.5', 'xuất sắc', '3.62', '8.77'),
                        _buildGradeRow('4', 'Học kỳ 2, năm 2024 - 2025', '3.25', '8.82', '', '', ''),
                      ],
                    ),
                  ),
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

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  TableRow _buildGradeRow(
    String number,
    String semester,
    String grade4,
    String grade10,
    String rating,
    String cumGrade4,
    String cumGrade10,
  ) {
    return TableRow(
      children: [
        _buildTableCell(number),
        _buildTableCell(semester, align: TextAlign.left),
        _buildTableCell(grade4, color: grade4.isNotEmpty ? const Color(0xFFE53935) : null),
        _buildTableCell(grade10),
        _buildTableCell(rating, color: rating.contains('xuất sắc') ? const Color(0xFFE53935) : null),
        _buildTableCell(cumGrade4),
        _buildTableCell(cumGrade10),
      ],
    );
  }

  Widget _buildTableCell(String text, {TextAlign align = TextAlign.center, Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 12,
          color: color ?? Colors.black87,
          fontWeight: color != null ? FontWeight.bold : FontWeight.normal,
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
