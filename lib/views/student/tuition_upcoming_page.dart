import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../data/dev_mock_data.dart';

class TuitionUpcomingPage extends StatelessWidget {
  final Student student;

  const TuitionUpcomingPage({super.key, required this.student});

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
    final headerColor = const Color(0xFF415A6D);

    final totalChargeCredits = devMockTuitionCharges.fold<int>(
      0,
      (sum, c) => sum + c.credits,
    );
    final totalChargeAmount = devMockTuitionCharges.fold<int>(
      0,
      (sum, c) => sum + c.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Học phí sắp tới',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF213C73),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Hình thức nộp học phí theo thông báo chính thức của Phòng Kế hoạch Tài Chính',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7780)),
              ),
              const SizedBox(height: 12),

              // Charges table with QR placeholder (responsive)
              const Text(
                'Danh sách học phí và chi tiết',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  final left = Expanded(
                    flex: 3,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: devMockTuitionCharges.isEmpty
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEB5757),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text('Bạn chưa nộp học phí'),
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    DataTable(
                                      headingRowColor: WidgetStateProperty.all(
                                        headerColor,
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
                                          devMockTuitionCharges.length,
                                          (index) {
                                            final c =
                                                devMockTuitionCharges[index];
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
                                                  Text(
                                                    formatCurrency(c.amount),
                                                  ),
                                                ),
                                                DataCell(Text(c.invoiceLabel)),
                                              ],
                                            );
                                          },
                                        ),
                                        if (totalChargeAmount > 0)
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
                                                  '$totalChargeCredits',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  formatCurrency(
                                                    totalChargeAmount,
                                                  ),
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
                  );

                  final right = SizedBox(
                    width: 340,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // QR placeholder box
                            Container(
                              height: 260,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade50,
                              ),
                              child: const Center(
                                child: Text(
                                  'QR placeholder (will be filled by API)',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // QR detail table / info area
                            // QR details (populated from API in real app)
                            Text(
                              'Số tiền: ${formatCurrency(devMockQrInfo.amount)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('Nội dung: ${devMockQrInfo.content}'),
                            const SizedBox(height: 6),
                            Text('Dịch vụ: ${devMockQrInfo.service}'),
                            const SizedBox(height: 6),
                            Text('Số TT: ${devMockQrInfo.ref}'),
                            const SizedBox(height: 6),
                            Text('Ngân hàng: ${devMockQrInfo.bank}'),
                          ],
                        ),
                      ),
                    ),
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [left, const SizedBox(width: 16), right],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [right, const SizedBox(height: 12), left],
                  );
                },
              ),

              const SizedBox(height: 24),
              const Text(
                'Danh sách học phí và các khoản phí đã nộp học kỳ này',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // Payments table
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: devMockTuitionPaid.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEB5757),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text('Bạn chưa nộp học phí'),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              headerColor,
                            ),
                            headingTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            columns: const [
                              DataColumn(label: Text('STT')),
                              DataColumn(label: Text('Số biên lai')),
                              DataColumn(label: Text('Biên lai')),
                              DataColumn(label: Text('Người thu')),
                              DataColumn(label: Text('Ngày thu')),
                            ],
                            rows: [
                              ...List<DataRow>.generate(
                                devMockTuitionPaid.length,
                                (index) {
                                  final r = devMockTuitionPaid[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(Text(r.receiptNumber)),
                                      DataCell(Text(r.details)),
                                      DataCell(Text(r.receiver)),
                                      DataCell(Text(r.date)),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
