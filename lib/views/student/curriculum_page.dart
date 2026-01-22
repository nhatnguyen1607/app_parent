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
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
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
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 800),
                          child: SingleChildScrollView(
                            child: _buildCoursesTable(courses),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTable(List<Course> courses) {
    final oddColor = const Color.fromARGB(255, 253, 253, 253);
    final evenColor = const Color(0xFFE7F1FF);

    return DataTable(
      headingRowColor: WidgetStateProperty.all(const Color(0xFF415A6D)),
      headingTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      columns: const [
        DataColumn(label: Text('STT')),
        DataColumn(label: Text('Mã học phần')),
        DataColumn(label: Text('Tên học phần')),
        DataColumn(label: Text('Số Tín chỉ')),
        DataColumn(label: Text('Khối kiến thức')),
        DataColumn(label: Text('Tự chọn/Bắt buộc')),
        DataColumn(label: Text('Học kỳ')),
        DataColumn(label: Text('Đã học (Điểm đạt được)')),
      ],
      rows: List<DataRow>.generate(courses.length, (index) {
        final c = courses[index];
        final bg = (c.semester % 2 == 1) ? oddColor : evenColor;
        return DataRow(
          color: WidgetStateProperty.all(bg),
          cells: [
            DataCell(Text('${index + 1}')),
            DataCell(Text(c.code)),
            DataCell(SizedBox(width: 300, child: Text(c.name))),
            DataCell(Text('${c.credits}')),
            DataCell(Text(c.knowledgeBlock)),
            DataCell(Text(c.requiredType)),
            DataCell(Text('${c.semester}')),
            DataCell(Text(c.grade != null ? c.grade!.toString() : '')),
          ],
        );
      }),
    );
  }
}
