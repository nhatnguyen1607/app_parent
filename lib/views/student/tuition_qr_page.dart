import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/qr_hocphi_model.dart';
import '../../controllers/qr_hocphi_controller.dart';

class TuitionQrPage extends StatefulWidget {
  final Student student;

  const TuitionQrPage({super.key, required this.student});

  @override
  State<TuitionQrPage> createState() => _TuitionQrPageState();
}

class _TuitionQrPageState extends State<TuitionQrPage> {
  late Future<QrHocPhiData> _qrFuture;
  final QrHocPhiController _controller = QrHocPhiController();

  @override
  void initState() {
    super.initState();
    _qrFuture = _controller.getQrHocPhi(widget.student.studentCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mã QR thanh toán học phí',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF213C73),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<QrHocPhiData>(
        future: _qrFuture,
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

          final data = snapshot.data;
          if (data == null || !data.hasImage) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_2_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có mã QR thanh toán',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Quét mã QR để thanh toán học phí qua ngân hàng',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildQrImage(data),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mã SV: ${widget.student.studentCode}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
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
      return Image.memory(
        bytes,
        width: 280,
        height: 280,
        fit: BoxFit.contain,
      );
    }
    return SizedBox(
      width: 280,
      height: 280,
      child: Center(
        child: Icon(Icons.broken_image_outlined, size: 64, color: Colors.grey[400]),
      ),
    );
  }
}
