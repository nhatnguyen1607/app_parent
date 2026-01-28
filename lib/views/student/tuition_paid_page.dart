import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/tuition_paid_model.dart';
import '../../controllers/tuition_paid_controller.dart';

class TuitionPaidPage extends StatefulWidget {
  final Student student;

  const TuitionPaidPage({super.key, required this.student});

  @override
  State<TuitionPaidPage> createState() => _TuitionPaidPageState();
}

class _TuitionPaidPageState extends State<TuitionPaidPage> {
  late Future<List<TuitionPaidItem>> _paidFuture;
  final TuitionPaidController _controller = TuitionPaidController();

  @override
  void initState() {
    super.initState();
    _paidFuture = _controller.getTuitionPaid(widget.student.studentCode);
  }

  static String formatCurrency(int value) {
    // naive thousands separator for VND
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
        title: const Text('Học phí', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF213C73),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<TuitionPaidItem>>(
        future: _paidFuture,
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

          final tuitionPaid = snapshot.data ?? [];
          final totalPaid = tuitionPaid.fold<int>(
            0,
            (sum, r) => sum + r.tongtien,
          );

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Danh sách học phí đã nộp',
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
                                DataColumn(label: Text('STT')),
                                DataColumn(label: Text('Số biên lai')),
                                DataColumn(label: Text('Số tiền (VNĐ)')),
                                DataColumn(label: Text('Ngày thu')),
                                DataColumn(label: Text('Học kỳ năm')),
                              ],
                              rows: [
                                ...List<DataRow>.generate(tuitionPaid.length, (
                                  index,
                                ) {
                                  final r = tuitionPaid[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(Text(r.sobienlai)),
                                      DataCell(
                                        Text(formatCurrency(r.tongtien)),
                                      ),
                                      DataCell(Text(r.ngaythuDisplay)),
                                      DataCell(Text(r.hocKyNamText)),
                                    ],
                                  );
                                }),
                                if (totalPaid > 0)
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
                                      DataCell(
                                        Text(
                                          formatCurrency(totalPaid),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const DataCell(Text('')),
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
                    'Lưu ý: Các khoản phí tạm phí của Tân sinh viên sẽ sớm được cập nhật',
                    style: TextStyle(color: Colors.grey),
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
