import 'package:flutter/material.dart';
import '../../models/student_model.dart';

class ExamSchedulePage extends StatelessWidget {
  final Student student;

  const ExamSchedulePage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch thi kết thúc học kỳ 2, năm học 2025 - 2026',
          style: TextStyle(color: Colors.white, fontSize: 16),
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
              _buildExamTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamTable() {
    final exams = [
      {
        'subject': 'Chuyên đề 2 (IT) (5)Khai phá dữ liệu Web',
        'teacher': 'ThS. Mai Lam',
        'credits': '2',
        'datetime': 'H/thức thi cuối kỳ',
        'day': 'Ngày thi',
        'room': 'Giờ thi',
        'note': 'Phòng thi',
      },
      {
        'subject': 'Đồ án chuyên ngành 1 (IT) (1)',
        'teacher': 'Khoa. KH MT',
        'credits': '1',
        'datetime': '',
        'day': '',
        'room': '',
        'note': '',
      },
      {
        'subject': 'Hệ chuyên gia (1)',
        'teacher': 'TS. Lê Tân',
        'credits': '2',
        'datetime': '',
        'day': '',
        'room': '',
        'note': '',
      },
      {
        'subject': 'Học sâu (5)',
        'teacher': 'TS. Lê Thị Thu Nga',
        'credits': '3',
        'datetime': '',
        'day': '',
        'room': '',
        'note': '',
      },
      {
        'subject': 'Học tăng cường_2 tín chỉ (1)',
        'teacher': 'TS. Nguyễn Hữu Nhật Minh',
        'credits': '2',
        'datetime': '',
        'day': '',
        'room': '',
        'note': '',
      },
      {
        'subject': 'Triết học Mác - Lênin (4)',
        'teacher': 'TS. Dương Thị Phương',
        'credits': '3',
        'datetime': '',
        'day': '',
        'room': '',
        'note': '',
      },
      {
        'subject': 'Tiếng Anh nâng cao 4 (1)',
        'teacher': 'TS. Trần Thị Thúy Liên',
        'credits': '2',
        'datetime': '',
        'day': '',
        'room': '',
        'note': '',
      },
    ];

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
          constraints: const BoxConstraints(minWidth: 1000),
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
                    SizedBox(width: 280, child: _buildHeaderCell('Tên lớp học phần', flex: 1)),
                    SizedBox(width: 200, child: _buildHeaderCell('Giảng viên', flex: 1)),
                    SizedBox(width: 80, child: _buildHeaderCell('Số TC', flex: 1)),
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
                      SizedBox(width: 280, child: _buildDataCell(exam['subject']!, flex: 1)),
                      SizedBox(width: 200, child: _buildDataCell(exam['teacher']!, flex: 1)),
                      SizedBox(width: 80, child: _buildDataCell(exam['credits']!, flex: 1)),
                      SizedBox(width: 150, child: _buildDataCell(exam['datetime']!, flex: 1)),
                      SizedBox(width: 120, child: _buildDataCell(exam['day']!, flex: 1)),
                      SizedBox(width: 120, child: _buildDataCell(exam['room']!, flex: 1)),
                      SizedBox(width: 120, child: _buildDataCell(exam['note']!, flex: 1)),
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
    return Expanded(
      flex: flex,
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
    return Expanded(
      flex: flex,
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
