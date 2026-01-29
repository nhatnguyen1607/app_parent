import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/attendance_model.dart';
import '../../controllers/attendance_controller.dart';

class AttendancePage extends StatefulWidget {
  final Student student;

  const AttendancePage({super.key, required this.student});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final AttendanceController _controller = AttendanceController();
  List<Attendance> _attendances = [];
  List<Map<String, dynamic>> _allSemesters = [];
  bool _isLoading = true;
  int _selectedNamhoc = 0;
  int _selectedHocky = 1;

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
    });
    // Lấy tình trạng chuyên cần
    await _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    setState(() {
      _isLoading = true;
    });

    final attendances = await _controller.getAttendance(
      widget.student.studentCode,
      _selectedNamhoc,
      _selectedHocky,
    );

    setState(() {
      _attendances = attendances;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tình trạng chuyên cần',
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
                'Tình trạng chuyên cần',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Thông tin về các buổi học mà sinh viên vắng mặt trong học kỳ',
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
                              });
                              _loadAttendance();
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
                              _loadAttendance();
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
                  : _attendances.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'Sinh viên đi học đầy đủ trong học kỳ này',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        )
                      : _buildAttendanceTable(),
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

  Widget _buildAttendanceTable() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: _attendances.asMap().entries.map((entry) {
          int index = entry.key;
          Attendance attendance = entry.value;
        
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
                      attendance.tenlop,
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
              _buildInfoRow('Giảng viên', attendance.teacherName),
              const SizedBox(height: 6),
              _buildInfoRow('Ngày nghỉ', attendance.formattedDate),
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
