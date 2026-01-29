import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../models/student_model.dart';
import '../../models/tuition_payment_model.dart';
import '../../controllers/tuition_payment_controller.dart';
import '../../controllers/qr_hocphi_controller.dart';
import '../../models/qr_hocphi_model.dart';

class TuitionPaymentPage extends StatefulWidget {
  final Student student;

  const TuitionPaymentPage({super.key, required this.student});

  @override
  State<TuitionPaymentPage> createState() => _TuitionPaymentPageState();
}

class _TuitionPaymentPageState extends State<TuitionPaymentPage> {
  late Future<List<UpcomingTuition>> _upcomingFuture;
  late Future<QrHocPhiData> _qrFuture;
  final TuitionPaymentController _controller = TuitionPaymentController();
  final QrHocPhiController _qrController = QrHocPhiController();

  @override
  void initState() {
    super.initState();
    _upcomingFuture = _controller.getUpcomingTuition(
      widget.student.studentCode,
    );
    _qrFuture = _qrController.getQrHocPhi(widget.student.studentCode);
  }

  static String formatCurrency(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write(',');
        count = 0;
      }
    }
    return buffer.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    final tableHeaderColor = const Color(0xFF415A6D);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đóng học phí',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF213C73),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_upcomingFuture, _qrFuture]),
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

          final upcomingData =
              snapshot.data?[0] as List<UpcomingTuition>? ?? const [];
          final qrData = snapshot.data?[1] as QrHocPhiData?;
          final totalAmount = upcomingData.fold<int>(
            0,
            (sum, item) => sum + item.thanhTien,
          );

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Mã QR thanh toán',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildQrSection(qrData),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Lưu ý: Sinh viên kiểm tra khối lượng và tiền nộp trước khi thanh toán',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Danh sách học phí sắp tới',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  // Hiển thị dạng card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                      ...upcomingData.asMap().entries.map((entry) {
                        int index = entry.key;
                        final item = entry.value;
                        
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
                                      item.tenLop,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _buildInfoRow('Số tín chỉ', '${item.soTC}'),
                                  ),
                                  Expanded(
                                    child: _buildInfoRow('Lần học', item.lanHoc),
                                  ),
                                ],
                              ),
                              const Divider(height: 20),
                              // Số tiền
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Thành tiền',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${formatCurrency(item.thanhTien)} VNĐ',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF213C73),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      // Tổng
                      if (totalAmount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF213C73),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng cộng:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${formatCurrency(totalAmount)} VNĐ',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildQrSection(QrHocPhiData? data) {
    if (data == null) {
      return _qrEmpty('Chưa có dữ liệu mã QR');
    }
    if (!data.hasImage) {
      return _qrEmpty('Chưa có mã QR thanh toán');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quét mã QR để thanh toán học phí qua ngân hàng',
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        const SizedBox(height: 12),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildQrImage(data),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Mã SV: ${widget.student.studentCode}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _qrEmpty(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Icon(Icons.qr_code_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildQrImage(QrHocPhiData data) {
    if (data.imageUrl != null && data.imageUrl!.isNotEmpty) {
      return Image.network(
        data.imageUrl!,
        width: 280,
        height: 280,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _fallbackFromBytes(data.imageBytes),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: 280,
            height: 280,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    }
    if (data.imageBytes != null && data.imageBytes!.isNotEmpty) {
      return Image.memory(
        data.imageBytes!,
        width: 280,
        height: 280,
        fit: BoxFit.contain,
      );
    }
    return _fallbackFromBytes(null);
  }

  Widget _fallbackFromBytes(Uint8List? bytes) {
    if (bytes != null && bytes.isNotEmpty) {
      return Image.memory(bytes, width: 280, height: 280, fit: BoxFit.contain);
    }
    return SizedBox(
      width: 280,
      height: 280,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 64,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
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
      ),
    );
  }
}
