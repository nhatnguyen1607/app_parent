import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/tuition_payment_model.dart';
import '../../controllers/tuition_payment_controller.dart';

class TuitionPaymentPage extends StatefulWidget {
  final Student student;

  const TuitionPaymentPage({super.key, required this.student});

  @override
  State<TuitionPaymentPage> createState() => _TuitionPaymentPageState();
}

class _TuitionPaymentPageState extends State<TuitionPaymentPage> {
  late Future<List<UpcomingTuition>> _upcomingFuture;
  final TuitionPaymentController _controller = TuitionPaymentController();

  @override
  void initState() {
    super.initState();
    _upcomingFuture = _controller.getUpcomingTuition(widget.student.studentCode);
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
          'Học phí sắp tới',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF213C73),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<UpcomingTuition>>(
        future: _upcomingFuture,
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

          final upcomingData = snapshot.data ?? [];
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
                    'Danh sách học phí sắp tới',
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
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            tableHeaderColor,
                          ),
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          columns: const [
                            DataColumn(label: Text('STT')),
                            DataColumn(label: Text('Tên lớp')),
                            DataColumn(label: Text('Số TC')),
                            DataColumn(label: Text('Lần học')),
                            DataColumn(label: Text('Thành tiền')),
                          ],
                          rows: [
                            ...List<DataRow>.generate(
                              upcomingData.length,
                              (index) {
                                final item = upcomingData[index];
                                return DataRow(
                                  cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(
                                      SizedBox(
                                        width: 300,
                                        child: Text(item.tenLop),
                                      ),
                                    ),
                                    DataCell(Text('${item.soTC}')),
                                    DataCell(Text(item.lanHoc)),
                                    DataCell(
                                      Text(formatCurrency(item.thanhTien)),
                                    ),
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
                                  const DataCell(Text('')),
                                  DataCell(
                                    Text(
                                      formatCurrency(totalAmount),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                    'Lưu ý: Sinh viên kiểm tra khối lượng và tiền nộp trước khi thanh toán',
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
