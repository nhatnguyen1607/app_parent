class ExamSchedule {
  final String subject; // Tên lớp học phần (tenlop)
  final String examType; // H/thức thi cuối kỳ (tenhinhthuc)
  final String examDate; // Ngày thi (ngay_thi - chỉ lấy phần ngày)
  final String examTime; // Giờ thi (gio_thi)
  final String examRoom; // Phòng thi (tenphong)

  ExamSchedule({
    required this.subject,
    required this.examType,
    required this.examDate,
    required this.examTime,
    required this.examRoom,
  });

  factory ExamSchedule.fromJson(Map<String, dynamic> json) {
    return ExamSchedule(
      subject: json['tenlop']?.toString() ?? '',
      examType: json['tenhinhthuc']?.toString() ?? '',
      examDate: _formatDate(json['ngay_thi']?.toString() ?? ''),
      examTime: json['gio_thi']?.toString() ?? '',
      examRoom: json['tenphong']?.toString() ?? '',
    );
  }

  // Format ngày từ "2025-12-20 00:00:00" thành "20/12/2025"
  static String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    
    try {
      // Lấy phần ngày trước dấu cách (bỏ phần giờ)
      final datePart = dateString.split(' ').first;
      final parts = datePart.split('-');
      
      if (parts.length == 3) {
        // Format từ yyyy-MM-dd thành dd/MM/yyyy
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      
      return datePart;
    } catch (e) {
      return dateString;
    }
  }
}
