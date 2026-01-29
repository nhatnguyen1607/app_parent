import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/certificate_model.dart';
import '../../repositories/certificate_repository.dart';

class CertificatePage extends StatefulWidget {
  final Student student;

  const CertificatePage({super.key, required this.student});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  late Future<Certificate?> _certificateFuture;

  @override
  void initState() {
    super.initState();
    _certificateFuture = ApiCertificateRepository().fetchCertificate(
      widget.student,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tableHeaderColor = const Color(0xFF415A6D);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chứng chỉ Tốt nghiệp',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF213C73),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Certificate?>(
        future: _certificateFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final certificate = snapshot.data;
          if (certificate == null) {
            return const Center(child: Text('Không có dữ liệu chứng chỉ'));
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Chứng chỉ Tốt nghiệp',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                // Card hiển thị chứng chỉ
                Container(
                  padding: const EdgeInsets.all(16),
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
                      // Header - Tên sinh viên
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Color(0xFF213C73),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              certificate.studentName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF213C73),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      // Các chứng chỉ
                      _buildCertificateRow(
                        'Chứng chỉ Giáo dục thể chất',
                        certificate.physicalEducation ?? 'Chưa có',
                        Icons.fitness_center,
                      ),
                      const SizedBox(height: 12),
                      _buildCertificateRow(
                        'Chứng chỉ Giáo dục quốc phòng',
                        certificate.nationalDefense ?? 'Chưa có',
                        Icons.security,
                      ),
                      const SizedBox(height: 12),
                      _buildCertificateRow(
                        'Chứng chỉ Ngoại ngữ',
                        certificate.foreignLanguage ?? 'Chưa có',
                        Icons.language,
                      ),
                      const SizedBox(height: 12),
                      _buildCertificateRow(
                        'Chứng chỉ Tin học',
                        certificate.informatics ?? 'Chưa có',
                        Icons.computer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCertificateRow(String label, String value, IconData icon) {
    final bool hasValue = value != 'Chưa có';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasValue ? const Color(0xFFE8F5E9) : Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: hasValue ? Colors.green[200]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: hasValue ? Colors.green[700] : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: hasValue ? Colors.green[800] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (hasValue)
            Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: 20,
            ),
        ],
      ),
    );
  }
}
