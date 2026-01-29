import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/schedule_model.dart';
import '../../models/absence_model.dart';
import '../../models/makeup_model.dart';
import '../../controllers/schedule_controller.dart';
import '../../controllers/absence_controller.dart';

class SchedulePage extends StatefulWidget {
  final Student student;

  const SchedulePage({super.key, required this.student});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScheduleController _controller = ScheduleController();
  final AbsenceController _absenceController = AbsenceController();
  List<Schedule> _schedules = [];
  List<Absence> _absences = [];
  List<Makeup> _makeups = [];
  List<Map<String, dynamic>> _allSemesters = [];
  bool _isLoading = true;
  bool _isLoadingAbsences = true;
  bool _isLoadingMakeups = true;
  int _selectedNamhoc = 0;
  int _selectedHocky = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadAbsencesAndMakeups();
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

  Future<void> _loadAbsencesAndMakeups() async {
    setState(() {
      _isLoadingAbsences = true;
      _isLoadingMakeups = true;
    });

    final absences = await _absenceController.getAbsences(widget.student.studentCode);
    final makeups = await _absenceController.getMakeups(widget.student.studentCode);

    setState(() {
      _absences = absences;
      _makeups = makeups;
      _isLoadingAbsences = false;
      _isLoadingMakeups = false;
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
              
              const SizedBox(height: 24),
              Text(
                'Báo nghỉ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              _isLoadingAbsences
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _absences.isEmpty
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
                                  'Không có báo nghỉ',
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
                      : _buildAbsencesSection(),

              const SizedBox(height: 24),
              Text(
                'Dạy bù',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              _isLoadingMakeups
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _makeups.isEmpty
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
                                  'Không có dạy bù',
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
                      : _buildMakeupsSection(),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: _schedules.asMap().entries.map((entry) {
          int index = entry.key;
          Schedule schedule = entry.value;
        
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
                      schedule.tenlop,
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
              _buildInfoRow('Giảng viên', schedule.teacherName),
              const SizedBox(height: 6),
              // _buildInfoRow('Phòng', schedule.phong),
              // const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow('Phòng', schedule.phong),
                  ),
                  Expanded(
                    child: _buildInfoRow('Tiết', schedule.tiet),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow('Thứ', schedule.thu),
                  ),
                  Expanded(
                    child: _buildInfoRow('Giờ', schedule.timeSession),
                  ),
                ],
              ),
            ],
          ),
        );
        }).toList(),
      ),
    );
  }

  Widget _buildAbsencesSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: _absences.asMap().entries.map((entry) {
          int index = entry.key;
          Absence absence = entry.value;

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
                        absence.tenlop,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.event_busy, color: Colors.red[700], size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                // Thông tin
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thời điểm báo nghỉ',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            absence.thoidiemFormatted,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              absence.lydo,
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

  Widget _buildMakeupsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: _makeups.asMap().entries.map((entry) {
          int index = entry.key;
          Makeup makeup = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
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
                        color: Colors.blue[700],
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
                        makeup.tenlop,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.event_available, color: Colors.blue[700], size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                // Thông tin
                Row(
                  children: [
                    Expanded(
                      child: _buildMakeupInfo('Tiết', makeup.tiet),
                    ),
                    Expanded(
                      child: _buildMakeupInfo('Phòng', makeup.phongText),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue[700], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ngày dạy bù',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              makeup.ngayFormatted,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[800],
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

  Widget _buildMakeupInfo(String label, String value) {
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
