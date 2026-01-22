import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/tuition_model.dart';
import '../../repositories/api_tuition_repository.dart';

class TuitionPaymentPage extends StatefulWidget {
  final Student student;

  const TuitionPaymentPage({super.key, required this.student});

  @override
  State<TuitionPaymentPage> createState() => _TuitionPaymentPageState();
}

class _TuitionPaymentPageState extends State<TuitionPaymentPage> {
  late Future<List<TuitionCharge>> _chargesFuture;

  @override
  void initState() {
    super.initState();
    _chargesFuture = ApiTuitionRepository().fetchTuitionCharges(widget.student);
  }

  String formatCurrency(int value) {
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
      body: FutureBuilder<List<TuitionCharge>>(
        future: _chargesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final tuitionCharges = snapshot.data ?? [];
          final totalCredits = tuitionCharges.fold<int>(
            0,
            (sum, c) => sum + c.credits,
          );
          final totalAmount = tuitionCharges.fold<int>(
            0,
            (sum, c) => sum + c.amount,
          );

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                                DataColumn(label: Text('STT')),
                                DataColumn(label: Text('Lớp học phần')),
                                DataColumn(label: Text('Lần học')),
                                DataColumn(label: Text('Số tín chỉ')),
                                DataColumn(label: Text('Tiền học')),
                                DataColumn(label: Text('Hóa đơn')),
                              ],
                              rows: [
                                ...List<DataRow>.generate(
                                  tuitionCharges.length,
                                  (index) {
                                    final c = tuitionCharges[index];
                                    return DataRow(
                                      cells: [
                                        DataCell(Text('${index + 1}')),
                                        DataCell(
                                          SizedBox(
                                            width: 300,
                                            child: Text(c.description),
                                          ),
                                        ),
                                        DataCell(Text('${c.session}')),
                                        DataCell(Text('${c.credits}')),
                                        DataCell(
                                          Text(formatCurrency(c.amount)),
                                        ),
                                        DataCell(Text(c.invoiceLabel)),
                                      ],
                                    );
                                  },
                                ),
                                if (totalAmount > 0)
                                  DataRow(
                                    cells: [
                                      const DataCell(
                                        Text(
                                          'Tổng',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const DataCell(Text('')),
                                      const DataCell(Text('')),
                                      DataCell(
                                        Text(
                                          '$totalCredits',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatCurrency(totalAmount),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const DataCell(Text('')),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Lưu ý:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Sinh viên kiểm tra khối lượng số tín chỉ và tiền nộp trước khi quét mã QR để thanh toán học phí.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '• Liên hệ với phòng Kế hoạch - Tài chính để được xử lý kịp thời trong trường hợp cần thiết (0236.3.667.114)',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
