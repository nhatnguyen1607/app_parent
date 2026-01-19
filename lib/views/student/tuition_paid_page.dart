import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/tuition_model.dart';
import '../../repositories/repository_provider.dart';

class TuitionPaidPage extends StatefulWidget {
  final Student student;

  const TuitionPaidPage({super.key, required this.student});

  @override
  State<TuitionPaidPage> createState() => _TuitionPaidPageState();
}

class _TuitionPaidPageState extends State<TuitionPaidPage> {
  late Future<List<TuitionRecord>> _paidFuture;
  late Future<List<TuitionRecord>> _refundsFuture;

  @override
  void initState() {
    super.initState();
    final repo = getTuitionRepository();
    _paidFuture = repo.fetchTuitionPaid(widget.student);
    _refundsFuture = repo.fetchTuitionRefunds(widget.student);
  }

  String formatCurrency(int value) {
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
      body: FutureBuilder<List<List<TuitionRecord>>>(
        future: Future.wait([_paidFuture, _refundsFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final tuitionPaid = snapshot.data?[0] ?? [];
          final tuitionRefunds = snapshot.data?[1] ?? [];

          final totalPaid = tuitionPaid.fold<int>(
            0,
            (sum, r) => sum + r.amount,
          );
          final totalRefunds = tuitionRefunds.fold<int>(
            0,
            (sum, r) => sum + r.amount,
          );

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Danh sách học phí đã nộp (cập nhật từ 12/2019)',
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
                                DataColumn(label: Text('Đơn vị thu')),
                                DataColumn(label: Text('Ngày thu')),
                                DataColumn(label: Text('Ghi chú')),
                              ],
                              rows: [
                                ...List<DataRow>.generate(tuitionPaid.length, (
                                  index,
                                ) {
                                  final r = tuitionPaid[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(Text(r.receiptNumber)),
                                      DataCell(Text(formatCurrency(r.amount))),
                                      DataCell(Text(r.receiver)),
                                      DataCell(Text(r.date)),
                                      DataCell(Text(r.details)),
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

                  const SizedBox(height: 24),
                  const Text(
                    'Danh sách học phí được hoàn trả (cập nhật từ 12/2019)',
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
                              showCheckboxColumn: false,
                              headingRowColor: WidgetStateProperty.all(
                                tableHeaderColor,
                              ),
                              headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              columns: const [
                                DataColumn(label: Text('STT')),
                                DataColumn(
                                  label: Text('Số tiền hoàn trả (VNĐ)'),
                                ),
                                DataColumn(label: Text('Ngày trả')),
                                DataColumn(label: Text('Lý do')),
                              ],
                              rows: [
                                ...List<DataRow>.generate(
                                  tuitionRefunds.length,
                                  (index) {
                                    final r = tuitionRefunds[index];
                                    return DataRow(
                                      cells: [
                                        DataCell(Text('${index + 1}')),
                                        DataCell(
                                          Text(formatCurrency(r.amount)),
                                        ),
                                        DataCell(Text(r.date)),
                                        DataCell(Text(r.details)),
                                      ],
                                    );
                                  },
                                ),
                                if (totalRefunds > 0)
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
                                          formatCurrency(totalRefunds),
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
