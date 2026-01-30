import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/curriculum_model.dart';
import '../../controllers/curriculum_controller.dart';

class CurriculumPage extends StatefulWidget {
  final Student student;

  const CurriculumPage({super.key, required this.student});

  @override
  State<CurriculumPage> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  static const Color _tableHeaderColor = Color(0xFF455A64);
  static const Color _rowEvenBg = Color(0xFFE3F2FD); // xanh nhẹ cho hocky chẵn

  late Future<CurriculumResult> _curriculumFuture;
  final CurriculumController _controller = CurriculumController();

  @override
  void initState() {
    super.initState();
    _curriculumFuture = _controller.getCurriculum(widget.student.studentCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chương trình học',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF213C73),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Chương trình học',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: FutureBuilder<CurriculumResult>(
                future: _curriculumFuture,
                builder: (context, snapshot) {
                  final sotctoithieu = snapshot.data?.sotctoithieu ?? 160;

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
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red[300],
                            ),
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

                  final result =
                      snapshot.data ??
                      CurriculumResult(items: [], sotctoithieu: 160);
                  final list = List<CurriculumItem>.from(result.items)
                    ..sort((a, b) => a.hocky.compareTo(b.hocky));

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Ô tóm tắt điều kiện tốt nghiệp (sotctoithieu từ API)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Điều kiện tốt nghiệp',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '- Số tín chỉ tối thiểu đạt được: $sotctoithieu',
                              ),
                              const Text(
                                '- Đáp ứng đủ các chứng chỉ tốt nghiệp.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (list.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Chưa có dữ liệu chương trình học',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              children: [
                                ...list.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  final isOddHocky = item.hocky % 2 == 1;
                                  final cardBg = isOddHocky
                                      ? Colors.white
                                      : _rowEvenBg;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _tableHeaderColor,
                                                borderRadius:
                                                    BorderRadius.circular(4),
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
                                                item.tenhocphan,
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
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildInfoRow(
                                                'Số TC',
                                                '${item.soTC}',
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildInfoRow(
                                                'Tự chọn',
                                                item.loaiHocPhan,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildInfoRow(
                                                'Học kỳ dự kiến học',
                                                '${item.hocky}',
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildInfoRow(
                                                'Khối lượng kiến thức',
                                                item.tenkhoiluongkienthuc,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
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
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
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
