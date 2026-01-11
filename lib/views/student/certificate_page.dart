import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../data/dev_mock_data.dart';

class CertificatePage extends StatelessWidget {
  final Student student;

  const CertificatePage({super.key, required this.student});

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Chứng chỉ Tốt nghiệp',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            tableHeaderColor,
                          ),
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          columns: const [
                            DataColumn(label: Text('Sinh viên')),
                            DataColumn(
                              label: Text('Chứng chỉ Giáo dục thể chất'),
                            ),
                            DataColumn(
                              label: Text('Chứng chỉ Giáo dục Quốc phòng'),
                            ),
                            DataColumn(label: Text('Chứng chỉ Ngoại ngữ')),
                            DataColumn(label: Text('Chứng chỉ Tin học')),
                          ],
                          rows: [
                            DataRow(
                              cells: [
                                DataCell(Text(devMockCertificate.studentName)),
                                DataCell(
                                  Text(
                                    devMockCertificate.physicalEducation ?? '',
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    devMockCertificate.nationalDefense ?? '',
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    devMockCertificate.foreignLanguage ?? '',
                                  ),
                                ),
                                DataCell(
                                  Text(devMockCertificate.informatics ?? ''),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
