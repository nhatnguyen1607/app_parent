import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/dormitory_info_model.dart';
import '../../controllers/dormitory_info_controller.dart';
import '../../controllers/schedule_controller.dart';

class DormitoryInfoPage extends StatefulWidget {
  final Student student;

  const DormitoryInfoPage({super.key, required this.student});

  @override
  State<DormitoryInfoPage> createState() => _DormitoryInfoPageState();
}

class _DormitoryInfoPageState extends State<DormitoryInfoPage> {
  late Future<List<dynamic>> _dataFuture;
  final DormitoryInfoController _controller = DormitoryInfoController();
  final ScheduleController _scheduleController = ScheduleController();

  @override
  void initState() {
    super.initState();
    _dataFuture = Future.wait([
      _controller.getStudentInfo(widget.student.studentCode),
      _scheduleController.getCurrentSemester(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin ký túc xá',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF213C73),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Lỗi: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }

          final results = snapshot.data;
          if (results == null || results.length < 2) {
            return const Center(child: Text('Không có dữ liệu'));
          }
          final list = results[0] as List<DormitoryInfoItem>;
          final currentSemester = results[1] as Map<String, dynamic>;
          final namHocText = (currentSemester['namhocText'] ?? '').toString();
          final hocky = currentSemester['hocky'] is int
              ? currentSemester['hocky'] as int
              : int.tryParse(currentSemester['hocky']?.toString() ?? '1') ?? 1;

          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.apartment, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Không tìm thấy thông tin ký túc xá',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Thông tin ký túc xá',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF213C73),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Thông tin phòng và trạng thái lưu trú',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ...list.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return _buildInfoCard(
                    item,
                    index + 1,
                    index < list.length - 1,
                    namHocText: namHocText,
                    hocKy: hocky,
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Một card thông tin KTX — năm học, học kỳ lấy từ API namhochocky (hiện hành)
  Widget _buildInfoCard(
    DormitoryInfoItem item,
    int stt,
    bool hasMarginBottom, {
    required String namHocText,
    required int hocKy,
  }) {
    final isDangO = item.trangThai.toLowerCase().contains('đang ở');
    final hocKyLabel = hocKy == 3 ? 'Học kỳ hè' : 'Học kỳ $hocKy';
    return Container(
      margin: EdgeInsets.only(bottom: hasMarginBottom ? 16 : 0),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF455A64),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#$stt',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.apartment, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.hoVaTen,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Bảng thông tin — Năm học, Học kỳ từ API namhochocky (hiện hành)
          _buildInfoRow('Mã sinh viên', item.maSinhVien),
          if (namHocText.isNotEmpty) _buildInfoRow('Năm học', namHocText),
          _buildInfoRow('Học kỳ', hocKyLabel),
          _buildInfoRow('Phòng', item.phong),
          _buildInfoRowWithStatus('Trạng thái', item.trangThai, isDangO),
        ],
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
            width: 120,
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

  Widget _buildInfoRowWithStatus(String label, String value, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F5E9) : null,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
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
            child: isActive
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
          ),
        ],
      ),
    );
  }
}
