import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/schedule_model.dart';
import '../../controllers/schedule_controller.dart';

class SchedulePage extends StatefulWidget {
  final Student student;

  const SchedulePage({super.key, required this.student});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScheduleController _controller = ScheduleController();
  List<Schedule> _schedules = [];
  List<Map<String, dynamic>> _allSemesters = [];
  bool _isLoading = true;
  int _selectedNamhoc = 0;
  int _selectedHocky = 1;
  String _selectedNamhocText = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Lấy danh sách tất cả học kỳ
    final allSemesters = await _controller.getAllSemesters();
    
    // Lấy học kỳ hiện hành
    final currentSemester = await _controller.getCurrentSemester();
    
    setState(() {
      _allSemesters = allSemesters;
      _selectedNamhoc = currentSemester['namhoc'] ?? 0;
      _selectedHocky = currentSemester['hocky'] ?? 1;
      _selectedNamhocText = currentSemester['namhocText'] ?? '';
    });
    // Lấy thời khóa biểu
    await _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() {
      _isLoading = true;
    });

    final schedules = await _controller.getSchedule(
      widget.student.studentCode,
      _selectedNamhoc,
      _selectedHocky,
    );

    setState(() {
      _schedules = schedules;
      _isLoading = false;
    });
  }

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
              
              // Select boxes for semester and year
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _selectedNamhoc,
                          isExpanded: true,
                          hint: const Text('Chọn năm học'),
                          items: _getUniqueYears().map((yearData) {
                            return DropdownMenuItem<int>(
                              value: yearData['id'],
                              child: Text(yearData['text']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedNamhoc = value;
                                // Cập nhật text
                                final yearData = _allSemesters.firstWhere(
                                  (s) => s['id'] == value,
                                  orElse: () => {},
                                );
                                _selectedNamhocText = yearData['namhocText'] ?? '';
                              });
                              _loadSchedule();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _selectedHocky,
                          isExpanded: true,
                          hint: const Text('Chọn học kỳ'),
                          items: [1, 2, 3].map((hocky) {
                            return DropdownMenuItem<int>(
                              value: hocky,
                              child: Text('Học kỳ $hocky'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedHocky = value;
                              });
                              _loadSchedule();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _schedules.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'Chưa có thời khóa biểu',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        )
                      : _buildScheduleTable(),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getUniqueYears() {
    final Map<int, Map<String, dynamic>> uniqueYears = {};
    
    for (var semester in _allSemesters) {
      final id = semester['id'];
      if (!uniqueYears.containsKey(id)) {
        uniqueYears[id] = {
          'id': id,
          'text': semester['namhocText'] ?? '',
        };
      }
    }
    
    return uniqueYears.values.toList();
  }

  Widget _buildScheduleTable() {
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
                    SizedBox(width: 150, child: _buildHeaderCell('Thời gian', flex: 1)),
                    SizedBox(width: 80, child: _buildHeaderCell('Tiết', flex: 1)),
                  ],
                ),
              ),
              // Table rows
              ..._schedules.asMap().entries.map((entry) {
                int index = entry.key;
                Schedule schedule = entry.value;
                Color bgColor = index % 2 == 0 ? Colors.white : Colors.grey[50]!;
                
                // Màu cho buổi học dựa trên thời gian
                // Color? timeColor;
                // if (schedule.timeSession.contains('15h00')) {
                //   timeColor = Colors.red;
                // } else if (schedule.timeSession.contains('07h30')) {
                //   timeColor = Colors.orange;
                // }
                
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
                      SizedBox(width: 280, child: _buildDataCell(schedule.tenlop, flex: 1)),
                      SizedBox(width: 200, child: _buildDataCell(schedule.teacherName, flex: 1)),
                      SizedBox(width: 150, child: _buildDataCell(schedule.tuan, flex: 1)),
                      SizedBox(width: 120, child: _buildDataCell(schedule.phong, flex: 1)),
                      SizedBox(width: 80, child: _buildDataCell(schedule.thu, flex: 1)),
                      SizedBox(
                        width: 150,
                        child: _buildDataCell(
                          schedule.timeSession,
                          flex: 1,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 80, child: _buildDataCell(schedule.tiet, flex: 1)),
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
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDataCell(String text, {int flex = 1, Color? color}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 10,
        color: color ?? Colors.black87,
      ),
    );
  }
}
