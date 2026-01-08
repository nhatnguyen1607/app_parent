import 'package:flutter/material.dart';
import '../../models/student_model.dart';

class SchedulePage extends StatelessWidget {
  final Student student;

  const SchedulePage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thời khóa biểu',
          style: TextStyle(color: Colors.white),
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
              Text(
                'Thời khóa biểu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Đối với các lớp chưa có thời khóa biểu. Các lớp này sẽ có lịch thông báo từ Khoa chuyên môn hoặc từ Giảng viên giảng dạy',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              _buildScheduleTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleTable() {
    final schedules = [
      {
        'subject': 'Chuyên đề 2 (IT) (5)Khai phá dữ liệu Web',
        'teacher': 'ThS. Mai Lam',
        'week': '23→27,31→38,40,41',
        'room': 'K.AT13',
        'day': 'Sáu',
        'time': 'Từ 03h00 Chiều',
        'period': '8→9',
      },
      {
        'subject': 'Hệ chuyên gia (1)',
        'teacher': 'TS. Lê Tân',
        'week': '23→27,31→38',
        'room': 'V.A304',
        'day': 'Sáu',
        'time': 'Từ 7h30 Sáng',
        'period': '1→3',
      },
      {
        'subject': 'Học sâu (5)',
        'teacher': 'TS. Lê Thị Thu Nga',
        'week': '23→27,31→40',
        'room': 'V.A210',
        'day': 'Tư',
        'time': 'Từ 01h00 Chiều',
        'period': '6→9',
      },
      {
        'subject': 'Học tăng cường_2 tín chỉ (1)',
        'teacher': 'TS. Nguyễn Hữu Nhật Minh',
        'week': '23→27,31→38',
        'room': 'V.A211',
        'day': 'Tư',
        'time': 'Từ 7h30 Sáng',
        'period': '1→3',
      },
      {
        'subject': 'Triết học Mác - Lênin (4)',
        'teacher': 'TS. Dương Thị Phương',
        'week': '23→27,31→37',
        'room': 'K.C106',
        'day': 'Hai',
        'time': 'Từ 01h00 Chiều',
        'period': '6→9',
      },
      {
        'subject': 'GDTC 4 (Bóng chuyền) (3)',
        'teacher': 'ThS. Nguyễn Văn Thắng',
        'week': '25→27,31→42',
        'room': 'K.Sân bóng chuyền 1',
        'day': 'Ba',
        'time': 'Từ 03h00 Chiều',
        'period': '8→9',
      },
      {
        'subject': 'Tiếng Anh nâng cao 4 (1)',
        'teacher': 'TS. Trần Thị Thúy Liên',
        'week': '23→27,31→40',
        'room': 'K.B102',
        'day': 'Ba',
        'time': 'Từ 9h30 Sáng',
        'period': '3→4',
      },
      {
        'subject': 'Đồ án chuyên ngành 1 (IT) (1)',
        'teacher': 'Khoa. KH MT',
        'week': '23→27,31→40',
        'room': '(Chọn)',
        'day': '',
        'time': '',
        'period': '',
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
                    SizedBox(width: 50, child: _buildHeaderCell('STT', flex: 1)),
                    SizedBox(width: 280, child: _buildHeaderCell('Lớp học phần', flex: 1)),
                    SizedBox(width: 200, child: _buildHeaderCell('Giảng viên', flex: 1)),
                    SizedBox(width: 150, child: _buildHeaderCell('Tuần', flex: 1)),
                    SizedBox(width: 120, child: _buildHeaderCell('Phòng', flex: 1)),
                    SizedBox(width: 80, child: _buildHeaderCell('Thứ', flex: 1)),
                    SizedBox(width: 150, child: _buildHeaderCell('Buổi', flex: 1)),
                    SizedBox(width: 80, child: _buildHeaderCell('Tiết', flex: 1)),
                  ],
                ),
              ),
              // Table rows
              ...schedules.asMap().entries.map((entry) {
                int index = entry.key;
                var schedule = entry.value;
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
                      SizedBox(width: 50, child: _buildDataCell('${index + 1}', flex: 1)),
                      SizedBox(width: 280, child: _buildDataCell(schedule['subject']!, flex: 1)),
                      SizedBox(width: 200, child: _buildDataCell(schedule['teacher']!, flex: 1)),
                      SizedBox(width: 150, child: _buildDataCell(schedule['week']!, flex: 1)),
                      SizedBox(width: 120, child: _buildDataCell(schedule['room']!, flex: 1)),
                      SizedBox(width: 80, child: _buildDataCell(schedule['day']!, flex: 1)),
                      SizedBox(
                        width: 150,
                        child: _buildDataCell(
                          schedule['time']!,
                          flex: 1,
                          color: schedule['time']!.contains('03h00') ? Colors.red : (schedule['time']!.contains('7h30') ? Colors.orange : Colors.black87),
                        ),
                      ),
                      SizedBox(width: 80, child: _buildDataCell(schedule['period']!, flex: 1)),
                    ],
                  ),
                );
              }).toList(),
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

  Widget _buildDataCell(String text, {int flex = 1, Color? color}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }
}
