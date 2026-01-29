import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/course_model.dart';
import '../../repositories/course_repository.dart';


class CurriculumPage extends StatefulWidget {
  final Student student;
  final CourseRepository? repository;

  const CurriculumPage({super.key, required this.student, this.repository});

  @override
  State<CurriculumPage> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  late CourseRepository _repository;
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? ApiCourseRepository();
    _coursesFuture = _repository.fetchCourses(widget.student);
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
            // Small summary box
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Điều kiện tốt nghiệp',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('- Số tín chỉ tối thiểu đạt được: 160'),
                  Text('- Đáp ứng đủ các chứng chỉ tốt nghiệp.'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Table title
            const Text(
              'Chương trình học',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),

            // Table card
            Expanded(
              child: FutureBuilder<List<Course>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }
                  final courses = snapshot.data ?? [];
                  return SingleChildScrollView(
                    child: _buildCoursesCards(courses),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesCards(List<Course> courses) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: courses.asMap().entries.map((entry) {
            int index = entry.key;
            final c = entry.value;
          
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
                        c.name,
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
                // Thông tin hàng 1
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow('Mã HP', c.code),
                    ),
                    Expanded(
                      child: _buildInfoRow('Tín chỉ', '${c.credits}'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Thông tin hàng 2
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow('Khối kiến thức', c.knowledgeBlock),
                    ),
                    Expanded(
                      child: _buildInfoRow('Loại', c.requiredType == 'Bắt buộc' ? 'Bắt buộc' : 'Tự chọn'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Thông tin hàng 3
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow('Học kỳ', 'Học kỳ ${c.semester}'),
                    ),
                    Expanded(
                      child: _buildInfoRow('Điểm', c.grade != null ? c.grade!.toString() : 'Chưa có'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
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
